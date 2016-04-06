//
//  CellSelectedBackgroundView.m
//  IDoerTW
//
//  Created by iosdev on 16/3/22.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "CellSelectedBackgroundView.h"

@implementation CellSelectedBackgroundView
- (id)initWithFrame:(CGRect)frame withLineWidth:(CGFloat)width withLineColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        UIView*topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, width)];
        topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        
        UIView*bootomLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - width, frame.size.width, width)];
        bootomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        topLine.backgroundColor = color;
        bootomLine.backgroundColor = color;
        [self addSubview:topLine];
        [self addSubview:bootomLine];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
