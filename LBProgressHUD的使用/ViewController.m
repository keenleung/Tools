//
//  ViewController.m
//  LBProgressHUD的使用
//
//  Created by Apple on 16/3/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "LBProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)LBShowProcess:(id)sender{
    
    [LBProgressHUD showHUDto:self.view animated:YES];
    
}

- (IBAction)LBHideProcess:(id)sender{
    
    
    [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


@end
