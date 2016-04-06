//
//  TopCollectionView.m
//  Excel
//
//  Created by iosdev on 16/3/29.
//  Copyright © 2016年 Doer. All rights reserved.
//

#import "TopCollectionView.h"
#import "ExcelView.h"
#import "TopCollectionViewCell.h"
NSString* const TopIdentifier_Excel = @"TopContentTableViewCell";

@interface TopCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation TopCollectionView
- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
}
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout*)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
//        UICollectionViewFlowLayout *lay = (UICollectionViewFlowLayout*)layout;
//        UICollectionViewFlowLayout* _layout = [[UICollectionViewFlowLayout alloc] init];
//        _layout.minimumLineSpacing = 1.0f;
//        _layout.minimumInteritemSpacing = 0.5f;
//        _layout.itemSize = lay.itemSize;
//        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        self.collectionViewLayout = _layout;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"TopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:TopIdentifier_Excel];
    }
    return self;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    [self.collectionViewLayout invalidateLayout];
//}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    [self setValue:[NSValue valueWithCGPoint:scrollView.contentOffset] forKey:Excel_topCollectionViewContentOffset];
}
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.excelView.dataSource respondsToSelector:@selector(numberOfColumnInExcelView:)]) {
        return [self.excelView.dataSource numberOfColumnInExcelView:self.excelView];
    }
    return 100;
}
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    TopCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:TopIdentifier_Excel forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.topLabel.backgroundColor = [UIColor colorWithRed:(0xf0 / 255.0)green:(0xf0 / 255.0)blue:(0xf0 / 255.0)alpha:1];
    if ([self.excelView.dataSource respondsToSelector:@selector(topCollectionView:cellForRowAtIndexPath:)]) {
        cell.topLabel.text = [self.excelView.dataSource topCollectionView:self cellForRowAtIndexPath:indexPath];
    }
    else
        cell.topLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];

    return cell;
}
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat width = self.excelView.contentWidth;
    if ([self.excelView.dataSource respondsToSelector:@selector(widthOfContentTableView:cellForRowAtIndexPath:)]) {
        width = [self.excelView.dataSource widthOfContentTableView:self.excelView.contentTbaleView cellForRowAtIndexPath:indexPath];
    }
    return CGSizeMake(width, self.excelView.topHeight - 1);
}
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    if ([self.excelView.delegate respondsToSelector:@selector(topCollectionView:didSelectRowAtIndexPath:)]) {
        [self.excelView.delegate topCollectionView:self didSelectRowAtIndexPath:indexPath];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
