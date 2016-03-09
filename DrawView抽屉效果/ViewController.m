//
//  ViewController.m
//  DrawView抽屉效果
//
//  Created by Apple on 16/3/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TableViewController *tableV = [[TableViewController alloc] init];
    tableV.view.backgroundColor = [UIColor purpleColor];
    tableV.view.frame = self.mainV.bounds;
    [self.mainV addSubview:tableV.view];
}

@end
