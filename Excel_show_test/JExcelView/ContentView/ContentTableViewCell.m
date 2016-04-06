//
//  ContentTableViewCell.m
//  Excel
//
//  Created by iosdev on 16/3/28.
//  Copyright © 2016年 Doer. All rights reserved.
//

#import "ContentTableViewCell.h"
#import "ContentCollectionViewCell.h"

#import "CellSelectedBackgroundView.h"

@implementation ContentTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.contentCollectionView.backgroundColor = [UIColor clearColor];
    self.contentCollectionView.showsHorizontalScrollIndicator = NO;
    self.contentCollectionView.alwaysBounceVertical = NO;

//    self.selectedBackgroundView = [[CellSelectedBackgroundView alloc] initWithFrame:CGRectZero withLineWidth:1.f withLineColor:[UIColor colorWithRed:(0xff / 255.0)green:(0x8e / 255.0)blue:(0x05 / 255.0)alpha:1]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
