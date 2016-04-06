//
//  ContentTableView.h
//  Excel
//
//  Created by iosdev on 16/3/29.
//  Copyright © 2016年 Doer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExcelView;
@class CellSelectedBackgroundView;

@interface ContentTableView : UITableView

@property (nonatomic, weak) ExcelView* excelView;
@property (nonatomic, strong) CellSelectedBackgroundView* seletedView;
@property (nonatomic, strong) NSIndexPath* seletedPath;
@property (nonatomic, strong) NSValue* contentTableViewContentOffset;
@property (nonatomic, strong) NSValue* collectionViewContentOffset;

@property (nonatomic, assign) CGPoint topOffset;

@end
