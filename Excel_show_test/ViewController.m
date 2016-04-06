//
//  ViewController.m
//  Excel_show_test
//
//  Created by iosdev on 16/4/6.
//  Copyright © 2016年 Doer. All rights reserved.
//

#import "ViewController.h"

#import "ExcelView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    ExcelView* excel = [[ExcelView alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height-20)];
    [self.view addSubview:excel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
