//
//  ViewController.m
//  ImageCycle(图片无线轮播)
//
//  Created by Apple on 16/3/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "PageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    PageView *pageView = [PageView pageView];
    [self.view addSubview:pageView];

    //    pageView.frame = CGRectMake(0, 0, 375, 200);
    //    NSLog(@"%f",[UIScreen mainScreen].currentMode.size.width);
    pageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);

    //pageView.imageNameArr = @[@"img_01"];
    //pageView.imageNameArr = @[@"img_01",@"img_02"];
    //pageView.imageNameArr = @[@"img_01",@"img_02",@"img_03"];
    pageView.imageNameArr = @[@"img_01",@"img_02",@"img_03", @"img_04", @"img_05"];

}

@end
