//
//  ExcelView.h
//  Excel
//
//  Created by iosdev on 16/3/29.
//  Copyright © 2016年 Doer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopCollectionView.h"

#import "LeftTableView.h"

#import "ContentTableView.h"

#import "Excel.h"

#import "CellSelectedBackgroundView.h"

@protocol ExcelViewDataSource;
@protocol ExcelViewDelegate;
@interface ExcelView : UIView
//暴露出来是为了  上下拉刷新问题
@property () ContentTableView* contentTbaleView;
//一部分  自己设置 了
//序号 的宽度
@property (nonatomic, assign) CGFloat leftWidth;
//列的高度
@property (nonatomic, assign) CGFloat topHeight;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, weak) id<ExcelViewDataSource> dataSource;
@property (nonatomic, weak) id<ExcelViewDelegate> delegate;
- (void)reloadData;
- (void)reloadTopCollectionViewData;
- (void)reloadLeftTableViewData;
- (void)reloadContentTbaleViewData;

@end

@protocol ExcelViewDataSource <NSObject>
//暂时就支持字符串
//LeftTableView 在区 与 行 上面 暂时和 ContentTableView 是相同的 只考虑相同的情况
//暂时默认 0 个区   可以设置多少个区未实现
@required

// 返回  多少 列
- (NSInteger)numberOfColumnInExcelView:(ExcelView*)excelView;

// 每一个区返回多少行
- (NSInteger)contentTableView:(ContentTableView*)contentTableView numberOfRowsInSection:(NSInteger)section;

// 返回 区 行 列 的数据
- (NSString*)contentTableView:(ContentTableView*)contentTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath withColumn:(NSInteger)column;

@optional
// 高度 区  行
- (CGFloat)heightOfContentTableView:(ContentTableView*)contentTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;
// 每一列的宽度
- (CGFloat)widthOfContentTableView:(ContentTableView*)contentTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;

// 每一列的标题  默认是 1 、2、3
- (NSString*)topCollectionView:(TopCollectionView*)topCollectionView cellForRowAtIndexPath:(NSIndexPath*)indexPath;
// 左边序号 内容   默认是 1、2、3、、、、
- (NSString*)leftTableView:(LeftTableView*)leftTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;

// 多少个区
//- (NSInteger)numberOfSectionsInTableView:(ContentTableView*)contentTableView;

@end

@protocol ExcelViewDelegate <NSObject>
@optional
//点击 top left content
- (void)topCollectionView:(TopCollectionView*)topCollectionView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)leftTableView:(LeftTableView*)leftTableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)contentTableView:(ContentTableView*)contentTableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath withColumn:(NSInteger)column;
- (void)contentTableView:(ContentTableView*)contentTableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;

@end