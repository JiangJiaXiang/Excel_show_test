//
//  ExcelView.m
//  Excel
//
//  Created by iosdev on 16/3/29.
//  Copyright © 2016年 Doer. All rights reserved.
//

#import "ExcelView.h"
#import "Excel.h"

@interface ExcelView () {
    LeftTableView* leftTableView;
    TopCollectionView* topCollectionView;
    //    ContentTableView *contentTbaleView;
    UIView* vertexView;
}
@end

@implementation ExcelView

@synthesize leftWidth, topHeight, contentWidth, contentHeight;

- (void)dealloc
{
    [leftTableView removeObserver:self forKeyPath:Excel_leftTableViewContentOffset];
    [self.contentTbaleView removeObserver:self forKeyPath:Excel_contentTableViewContentOffset];
    [topCollectionView removeObserver:self forKeyPath:Excel_topCollectionViewContentOffset];
    [self.contentTbaleView removeObserver:self forKeyPath:Excel_collectionViewContentOffset];
    
    [leftTableView removeObserver:self forKeyPath:Excel_seletedPath];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.layer.borderColor = [[UIColor colorWithRed:0xe5 / 255.0 green:0xe5 / 255.0 blue:0xe5 / 255.0 alpha:1.0] CGColor];
        self.layer.cornerRadius = 1.0f;
        self.layer.borderWidth = 1.0f;
        self.clipsToBounds = YES;

        leftWidth = LeftWidth;
        topHeight = TopHeight;
        contentWidth = ContentWidth;
        contentHeight = ContentHeight;
        
        self.contentTbaleView = [[ContentTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.contentTbaleView.backgroundColor = [UIColor colorWithRed:0xe5 / 255.0 green:0xe5 / 255.0 blue:0xe5 / 255.0 alpha:1];
        self.contentTbaleView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentTbaleView.excelView = self;
        [self addSubview:self.contentTbaleView]; //UIViewAutoresizingFlexibleLeftMargin |
        [self.contentTbaleView addObserver:self forKeyPath:Excel_contentTableViewContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self.contentTbaleView addObserver:self forKeyPath:Excel_collectionViewContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        vertexView = [[UIView alloc] initWithFrame:CGRectZero];
        vertexView.backgroundColor = [UIColor colorWithRed:(0xf0 / 255.0)green:(0xf0 / 255.0)blue:(0xf0 / 255.0)alpha:1];
        vertexView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:vertexView];
        
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1.0f;
        layout.minimumInteritemSpacing = 0.5f;
        layout.itemSize = CGSizeMake(contentWidth, topHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        topCollectionView = [[TopCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        topCollectionView.showsHorizontalScrollIndicator = NO;
        topCollectionView.showsVerticalScrollIndicator = NO;
        topCollectionView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        topCollectionView.excelView = self;
        topCollectionView.backgroundColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1];
        topCollectionView.layer.borderColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1].CGColor;
        //        self.layer.cornerRadius = 1.0f;
        topCollectionView.layer.borderWidth = 1.0f;
        topCollectionView.clipsToBounds = YES;
        [self addSubview:topCollectionView];
        [topCollectionView addObserver:self forKeyPath:Excel_topCollectionViewContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        leftTableView = [[LeftTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        leftTableView.showsVerticalScrollIndicator = NO;
        leftTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        leftTableView.excelView = self;
        //leftTableViewCell 的背景颜色就是 分割线的颜色
        leftTableView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1];
        leftTableView.layer.borderColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1].CGColor;
        leftTableView.layer.borderWidth = 1.0f;
        leftTableView.clipsToBounds = YES;
        [self addSubview:leftTableView];
        [leftTableView addObserver:self forKeyPath:Excel_leftTableViewContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [leftTableView addObserver:self forKeyPath:Excel_seletedPath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if ([keyPath isEqualToString:Excel_leftTableViewContentOffset]) {
        self.contentTbaleView.contentOffset = leftTableView.contentOffset;
    }
    else if ([keyPath isEqualToString:Excel_contentTableViewContentOffset]) {
        leftTableView.contentOffset = self.contentTbaleView.contentOffset;
    }
    else if ([keyPath isEqualToString:Excel_topCollectionViewContentOffset]) {
        self.contentTbaleView.topOffset = topCollectionView.contentOffset;
    }
    else if ([keyPath isEqualToString:Excel_collectionViewContentOffset]) {
        topCollectionView.contentOffset = [self.contentTbaleView.collectionViewContentOffset CGPointValue];
    }
    else if ([keyPath isEqualToString:Excel_seletedPath]) {
        self.contentTbaleView.seletedPath = leftTableView.seletedPath;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat superWidth = self.bounds.size.width;
    CGFloat superHeight = self.bounds.size.height;
    vertexView.frame = CGRectMake(0, 0, leftWidth, topHeight);
    leftTableView.frame = CGRectMake(0, topHeight - 1, leftWidth, superHeight - topHeight + 1);
    topCollectionView.frame = CGRectMake(leftWidth - 1, 0, superWidth - leftWidth + 1, topHeight);
    self.contentTbaleView.frame = CGRectMake(leftWidth - 1, topHeight, superWidth - leftWidth + 1, superHeight - topHeight);
    //    self.contentTbaleView.contentInset = UIEdgeInsetsMake(0, leftWidth, 0, 0);
}

- (void)reloadData
{
    [topCollectionView reloadData];
    [leftTableView reloadData];
    [self.contentTbaleView reloadData];
}
- (void)reloadTopCollectionViewData
{
    [topCollectionView reloadData];
}
- (void)reloadLeftTableViewData
{
    [leftTableView reloadData];
}
- (void)reloadContentTbaleViewData
{
    [self.contentTbaleView reloadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
