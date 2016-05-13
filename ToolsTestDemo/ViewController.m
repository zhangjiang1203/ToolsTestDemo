//
//  ViewController.m
//  ToolsTestDemo
//
//  Created by pg on 16/5/13.
//  Copyright © 2016年 DZHFCompany. All rights reserved.
//

#import "ViewController.h"
#import "ZJToolHelper.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer addSublayer:[ZJToolHelper createGradientLayer:@[[UIColor whiteColor],[UIColor redColor],[UIColor blueColor]] location:@[@(0.2),@(0.4),@(1.0)] start:CGPointMake(0, 0) end:CGPointMake(0, 1) frame:CGRectMake(100, 100, 200, 200)]];
}


@end
