//
//  LeftTableView.m
//  Excel
//
//  Created by iosdev on 16/3/29.
//  Copyright © 2016年 Doer. All rights reserved.
//

#import "LeftTableView.h"
#import "ExcelView.h"
#import "LeftTableViewCell.h"
NSString* const LeftIdentifier_Excel = @"LeftContentTableViewCell";

@interface LeftTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation LeftTableView
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
        [self registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:LeftIdentifier_Excel];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    //通知contentTableView滑动
    [self setValue:[NSValue valueWithCGPoint:scrollView.contentOffset] forKey:Excel_leftTableViewContentOffset];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.excelView.dataSource respondsToSelector:@selector(contentTableView:numberOfRowsInSection:)]) {
        return [self.excelView.dataSource contentTableView:self.excelView.contentTbaleView numberOfRowsInSection:section];
    }
    return 100;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    LeftTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:LeftIdentifier_Excel forIndexPath:indexPath];
    cell.serialNumberLabel.backgroundColor = [UIColor colorWithRed:(0xf0 / 255.0)green:(0xf0 / 255.0)blue:(0xf0 / 255.0)alpha:1];
    if ([self.excelView.dataSource respondsToSelector:@selector(leftTableView:cellForRowAtIndexPath:)]) {
        cell.serialNumberLabel.text = [self.excelView.dataSource leftTableView:self cellForRowAtIndexPath:indexPath];
    }
    else
        cell.serialNumberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.contentView.backgroundColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1];
    return cell;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat height = self.excelView.contentHeight;
    if ([self.excelView.dataSource respondsToSelector:@selector(heightOfContentTableView:cellForRowAtIndexPath:)]) {
        height = [self.excelView.dataSource heightOfContentTableView:self.excelView.contentTbaleView cellForRowAtIndexPath:indexPath];
    }
    if (indexPath.row == 0) {
        height = height + 1.5f;
    }
    return height;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //使用 self.seletedPath 会触发kvo
    _seletedPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    [self setValue:_seletedPath forKey:Excel_seletedPath];
    
    if ([self.excelView.delegate respondsToSelector:@selector(leftTableView:didSelectRowAtIndexPath:)]) {
        [self.excelView.delegate leftTableView:self didSelectRowAtIndexPath:indexPath];
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
