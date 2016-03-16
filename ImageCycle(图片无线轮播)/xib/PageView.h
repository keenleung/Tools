//
//  PageView.h
//  02-图片轮转封装
//
//  Created by Apple on 16/1/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageView : UIView

// 图片数据
@property (nonatomic, strong)NSArray *imageNameArr;

// 类工厂方法
+ (instancetype) pageView;

@end
