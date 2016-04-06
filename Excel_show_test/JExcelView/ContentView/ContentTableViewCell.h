//
//  ContentTableViewCell.h
//  Excel
//
//  Created by iosdev on 16/3/28.
//  Copyright © 2016年 Doer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentTableViewCell : UITableViewCell <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

@end
