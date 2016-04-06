//
//  TopCollectionView.h
//  Excel
//
//  Created by iosdev on 16/3/29.
//  Copyright © 2016年 Doer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExcelView;
@interface TopCollectionView : UICollectionView

@property (nonatomic, weak) ExcelView *excelView;

@property (nonatomic, strong) NSValue *topCollectionViewContentOffset;

@end
