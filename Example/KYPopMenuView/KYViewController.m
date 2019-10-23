//
//  KYViewController.m
//  KYPopMenuView
//
//  Created by longer on 10/22/2019.
//  Copyright (c) 2019 longer. All rights reserved.
//

#import "KYViewController.h"
#import "KYPopMenuView.h"

@interface KYViewController ()

@end

@implementation KYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 64, 80, 40)];
    [btn setTitle:@"menu" forState:(UIControlStateNormal)];
    [btn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(handleBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleBtnAction {
    KYPopMenuView *menuView = [[KYPopMenuView alloc] initWithMenuFrame:CGRectMake(20, 64 + 40, 80, 180) shapeSize:CGSizeMake(12, 8) shapeOffsetX:20 images:nil titleArray:@[@"a",@"b"]];
    menuView.cellBgColor = UIColor.greenColor;
    [menuView showInSuperView:self.view];
}

@end
