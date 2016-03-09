//
//  DragerViewController.m
//  Tools
//
//  Created by Apple on 16/3/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DragerViewController.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

@interface DragerViewController ()



@end

@implementation DragerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加子控件
    [self setUp];
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.mainV addGestureRecognizer:pan];
    
    //添加点按手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
}

//点按,让中间view复位
- (void)tap {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.mainV.frame = self.view.bounds;
    }];
}


#define targetR 275
#define targetL -275


//当拖动self.mainV时调用
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    //self.mainV移动
    CGPoint transP = [pan translationInView:self.mainV];
    //self.mainV.transform = CGAffineTransformTranslate(self.mainV.transform, transP.x, 0);
    //根据传入的偏移量计算self.mainV的frame
    self.mainV.frame = [self frameWithOffset:transP.x];
    
    if (self.mainV.frame.origin.x > 0) {
        //往右拖动,隐藏右边
        self.rightV.hidden = YES;
    }else if (self.mainV.frame.origin.x < 0) {
        //往左拖动,显示右边
        self.rightV.hidden = NO;
    }
    
    //当手指松开时判断
    
    if(pan.state == UIGestureRecognizerStateEnded) {
        CGFloat target = 0;
        
        if (self.mainV.frame.origin.x > screenW * 0.5) {
            //当x值大于屏幕宽度一半时, 自动定位右侧
            target = targetR;
        } else if (CGRectGetMaxX(self.mainV.frame) < screenW * 0.5) {
            //当最大x值,小于屏幕宽度一半,  自动定位左侧
            target = targetL;
        }
        
        CGFloat offset = target - self.mainV.frame.origin.x;
        [UIView animateWithDuration:0.5 animations:^{
            self.mainV.frame = [self frameWithOffset:offset];
        }];
        
        
    }
    
    
    
    //复位
    [pan setTranslation:CGPointZero inView:self.mainV];
    
}

#define maxY 100
//根据传入的偏移量计算self.mainV的frame
- (CGRect)frameWithOffset:(CGFloat)offset {
    
    CGRect frame = self.mainV.frame;
    frame.origin.x += offset;
    //y
    //当MainV的x等于屏幕宽度时,mainV的最大Y值等于100
    //fabs取绝对值.
    frame.origin.y = fabs(frame.origin.x * 100 / screenW);
    //height
    frame.size.height = screenH - (2 * frame.origin.y);
    
    return frame;
}




//添加子控件
- (void)setUp {
    //leftV
    UIView *leftV = [[UIView alloc] initWithFrame:self.view.bounds];
    leftV.backgroundColor = [UIColor blueColor];
    //self.leftV = leftV;
    _leftV = leftV;
    [self.view addSubview:leftV];
    
    //rigtV
    UIView *rigtV = [[UIView alloc] initWithFrame:self.view.bounds];
    rigtV.backgroundColor = [UIColor greenColor];
    //self.rightV = rigtV;
    _rightV = rigtV;
    [self.view addSubview:rigtV];
    
    //mainV
    UIView *mainV = [[UIView alloc] initWithFrame:self.view.bounds];
    mainV.backgroundColor = [UIColor redColor];
    //self.mainV = mainV;
    _mainV = mainV;
    [self.view addSubview:mainV];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
