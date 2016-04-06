//
//  ContentTableView.m
//  Excel
//
//  Created by iosdev on 16/3/29.
//  Copyright © 2016年 Doer. All rights reserved.
//

#import "ContentTableView.h"

#import "ContentTableViewCell.h"
#import "ContentCollectionViewCell.h"

#import "ExcelView.h"

NSString* const ContentIdentifier_Excel = @"ContentTableViewCell";
NSString* const CellIdentifier_Excel = @"CellCollectionViewCell";

//NSString* const kChangeToLoginSuccess = @"kChangeToLoginSuccess";

@interface ContentTableView () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat superWidth;
    CGFloat superHeight;
}

@property (weak, nonatomic) ContentTableViewCell* replaceCell;

@end

@implementation ContentTableView
- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.alwaysBounceHorizontal = NO;
        [self registerNib:[UINib nibWithNibName:@"ContentTableViewCell" bundle:nil] forCellReuseIdentifier:ContentIdentifier_Excel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (superWidth) { //当屏幕旋转的时候去刷新 便宜量
        if (superWidth != self.bounds.size.width) {
            superWidth = self.bounds.size.width;
            ContentTableViewCell* coll = [self.visibleCells firstObject];
            for (ContentTableViewCell* cell in self.visibleCells) {
                cell.contentCollectionView.contentOffset = coll.contentCollectionView.contentOffset;
            }
        }
    }
    else {
        superWidth = self.bounds.size.width;
        superHeight = self.bounds.size.height;
    }
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset
{
    /*
    if (scrollView == self) {
        int yy = targetContentOffset->y;
        int yushu = yy % 30; //应该是当前 [self.visibleCells firstObject] cell 的高度
        CGPoint point;
        if (yushu < 30 / 2) {
            point = CGPointMake(scrollView.contentOffset.x, yy - yushu);
        }
        else {
            point = CGPointMake(scrollView.contentOffset.x, yy - yushu + 30);
        }
        if (yushu) {
            [scrollView setContentOffset:point animated:YES];
        }
    }
     */
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView == self) {

        //通知lefTableView滑动
        [self setValue:[NSValue valueWithCGPoint:scrollView.contentOffset] forKey:Excel_contentTableViewContentOffset];
    }
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        if (scrollView.contentOffset.y != 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
            return;
        }
        @synchronized(self)
        {
            [self setValue:[NSValue valueWithCGPoint:scrollView.contentOffset] forKey:Excel_collectionViewContentOffset];
            for (ContentTableViewCell* cell in self.visibleCells) {
                cell.contentCollectionView.contentOffset = scrollView.contentOffset;
            }
        }
    }
}
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource>
//使用left 来解决这个问题
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.excelView.dataSource respondsToSelector:@selector(numberOfColumnInExcelView:)]) {
        return [self.excelView.dataSource numberOfColumnInExcelView:self.excelView];
    }
    return 100;
}
#pragma mark 设置 ContentTableViewCell 选中状态
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    //列号    indexPath.row
    NSIndexPath* contentIndexPath = [self getIndexPathWith:collectionView];
    //contentIndexPath  区 、 行    。
    ContentCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier_Excel forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if ([self.excelView.dataSource respondsToSelector:@selector(contentTableView:cellForRowAtIndexPath:withColumn:)]) {
        cell.contentLabel.text = [self.excelView.dataSource contentTableView:self cellForRowAtIndexPath:contentIndexPath withColumn:indexPath.row];
    }
    else
        cell.contentLabel.text = [NSString stringWithFormat:@"%ld_%ld_%ld", (long)contentIndexPath.section, (long)contentIndexPath.row, (long)indexPath.row];

    //content cell 的选中状态 必须在这个地方进行设置 否者会出问题 状态会被 collectionView遮挡掉
    ContentTableViewCell* cellll = [self cellForRowAtIndexPath:contentIndexPath];
    if (!cellll.selected) {
        if (_seletedPath && contentIndexPath.row == _seletedPath.row && contentIndexPath.section == _seletedPath.section) {
            cellll.selected = YES;
            cellll.selectedBackgroundView = self.seletedView;
        }
        else {
            cellll.selected = NO;
            cellll.selectedBackgroundView = nil; //这里 一定要置空  因为 关闭了 、、、UITableViewCellSelectionStyleNone
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{

    self.seletedPath = [self getIndexPathWith:collectionView];

    if ([self.excelView.delegate respondsToSelector:@selector(contentTableView:didSelectRowAtIndexPath:withColumn:)]) {
        [self.excelView.delegate contentTableView:self didSelectRowAtIndexPath:_seletedPath withColumn:indexPath.row];
    }
}
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSIndexPath* contentIndexPath = [self getIndexPathWith:collectionView];
    CGFloat height = self.excelView.contentHeight;
    CGFloat width = self.excelView.contentWidth;
    if ([self.excelView.dataSource respondsToSelector:@selector(heightOfContentTableView:cellForRowAtIndexPath:)]) {
        height = [self.excelView.dataSource heightOfContentTableView:self cellForRowAtIndexPath:contentIndexPath];
    }
    if ([self.excelView.dataSource respondsToSelector:@selector(widthOfContentTableView:cellForRowAtIndexPath:)]) {
        width = [self.excelView.dataSource widthOfContentTableView:self cellForRowAtIndexPath:indexPath];
    }

    return CGSizeMake(width, height - 1);
}
#pragma amrk -
#pragma amrk - UITableViewDataSource, UITableViewDelegate

- (UITableViewCell*)contentTableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //行 区  indexPath
    ContentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ContentIdentifier_Excel forIndexPath:indexPath];
    //xib 设置为 UITableViewCellSelectionStyleNone 中关闭 会我影响自定义的选中
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell.contentCollectionView registerNib:[UINib nibWithNibName:@"ContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier_Excel];

    cell.contentCollectionView.delegate = self;
    cell.contentCollectionView.dataSource = self;
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1.0f;
    layout.minimumInteritemSpacing = 0.5f;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cell.contentCollectionView.collectionViewLayout = layout;
    cell.contentCollectionView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [cell.contentCollectionView reloadData];

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.excelView.dataSource respondsToSelector:@selector(contentTableView:numberOfRowsInSection:)]) {
        return [self.excelView.dataSource contentTableView:self numberOfRowsInSection:section];
    }
    return 100;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [self contentTableView:tableView cellForRowAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([self.excelView.dataSource respondsToSelector:@selector(heightOfContentTableView:cellForRowAtIndexPath:)]) {
        return [self.excelView.dataSource heightOfContentTableView:self cellForRowAtIndexPath:indexPath];
    }
    return self.excelView.contentHeight;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)setTopOffset:(CGPoint)topOffset
{
    _topOffset = topOffset;
    for (ContentTableViewCell* cell in self.visibleCells) {
        cell.contentCollectionView.contentOffset = _topOffset;
    }
}
- (void)setSeletedPath:(NSIndexPath*)seletedPath
{
//    if (_seletedPath) {
//        [self reloadRowsAtIndexPaths:@[_seletedPath] withRowAnimation:UITableViewRowAnimationNone];
//    }
    _seletedPath = seletedPath;
    if (!seletedPath) {
        return;
    }
    ContentTableViewCell* contentTableViewCell = [self cellForRowAtIndexPath:_seletedPath];
    for (ContentTableViewCell* cell in self.visibleCells) {
        cell.selected = NO;
        cell.selectedBackgroundView = nil;
    }
    contentTableViewCell.selected = YES;
    contentTableViewCell.selectedBackgroundView = self.seletedView;
    
    
    //三点 1、在设置自定义的 选中view 之前 将cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //2、cell.selected = NO;    .selected = YES;    这两个属性必须一起进行设置
    //3、cell.selectedBackgroundView = nil;   .selectedBackgroundView = self.seletedView;    这两个属性必须一起进行设置
    
    if ([self.excelView.delegate respondsToSelector:@selector(contentTableView:didSelectRowAtIndexPath:)]) {
        [self.excelView.delegate contentTableView:self didSelectRowAtIndexPath:_seletedPath];
    }
}
- (NSIndexPath*)getIndexPathWith:(UICollectionView*)collectionView
{
    UITableViewCell* contentCell = (UITableViewCell*)collectionView.superview.superview;
    return [self indexPathForCell:contentCell];
}

- (CellSelectedBackgroundView*)seletedView
{
    if (!_seletedView) {
        _seletedView = [[CellSelectedBackgroundView alloc] initWithFrame:CGRectZero withLineWidth:1.f withLineColor:[UIColor colorWithRed:(0xff / 255.0)green:(0x8e / 255.0)blue:(0x05 / 255.0)alpha:1]];
    }
    return _seletedView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
