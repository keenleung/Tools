//
//  图片轮转封装, 使用 Autoresizing 自动调整大小和位置
//
//  Created by Apple on 16/1/28.
//  Copyright © 2016年 Apple. All rights reserved.
//


// 每隔多少时间换下一张图片
#define TIME 2.0

// 图片命名的前缀,后缀格式为"01,02,..,nn"
#define PrefixImageName @"img_"

// 去掉 NSLog
#define NSLog(...)


#import "PageView.h"

@interface PageView()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageContrl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// 子控件
@property (nonatomic, weak) UIImageView *leftImageView;
@property (nonatomic, weak) UIImageView *centerImageView;
@property (nonatomic, weak) UIImageView *rightImageView;

// 记录当前图片的下标(这里从1开始)
@property (nonatomic, assign) NSInteger currentIndex;

// 定时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PageView

// 类工厂方法, 构造 xib
+ (instancetype)pageView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 初始化 currentIndex 为 1
- (void)setImageNameArr:(NSArray *)imageNameArr{

    _imageNameArr = imageNameArr;

    self.currentIndex = 1;

    // 设置 pageControl 的页数
    self.pageContrl.numberOfPages = imageNameArr.count;

    if (self.imageNameArr.count == 1) {
        self.pageContrl.hidden = YES;
    }

    NSLog(@"---setImageNameArr");
}

// 设置各个 imageView 的 frame
-(void)layoutSubviews{

    [super layoutSubviews];

    CGFloat scrollViewW = self.scrollView.frame.size.width;
    CGFloat scrollViewH = self.scrollView.frame.size.height;

    // 设置 frame
    self.leftImageView.frame = CGRectMake(scrollViewW * 0, 0, scrollViewW, scrollViewH);
    self.centerImageView.frame = CGRectMake(scrollViewW * 1, 0, scrollViewW, scrollViewH);
    self.rightImageView.frame = CGRectMake(scrollViewW * 2, 0, scrollViewW, scrollViewH);

    // 设置 scrollView 的滚动范围
    self.scrollView.contentSize = CGSizeMake(scrollViewW * 3, 0);

    // 设置 scrollView 的偏移量,偏移到中间位置
    //self.scrollView.contentOffset = CGPointMake(1 * scrollViewW, 0);
    [self.scrollView setContentOffset:CGPointMake(1 * scrollViewW, 0) animated:NO];

    // 加载图片
    [self loadImage];

    // 开启定时器
    [self startTimer];

    NSLog(@"---layoutSubviews");
}

// xib 加载完毕后调用
-(void)awakeFromNib{

    // 添加3个 imageView
    // left
    UIImageView *leftImageView = [[UIImageView alloc] init];
    self.leftImageView = leftImageView;
    [self.scrollView addSubview:leftImageView];
    leftImageView.backgroundColor = [UIColor redColor];

    // center
    UIImageView *centerImageView = [[UIImageView alloc] init];
    self.centerImageView = centerImageView;
    [self.scrollView addSubview:centerImageView];
    centerImageView.backgroundColor = [UIColor blueColor];

    // right
    UIImageView *rightImageView = [[UIImageView alloc] init];
    self.rightImageView = rightImageView;
    [self.scrollView addSubview:rightImageView];
    rightImageView.backgroundColor = [UIColor yellowColor];

    // 设置 scrollView 的其他属性
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;

    NSLog(@"---awakeFromNib");
}

// 开启定时器
- (void) startTimer{
    // 1.创建一个自动执行任务的 timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIME target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];

    // 2.把 timer 放入 NSRunloop 中, 使用NSRunLoopCommonModes模式处理 timer
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

    NSLog(@"---startTime");
}

// 停止定时器
- (void) stopTimer{
    [self.timer invalidate];
}

// 定时器要执行的操作
- (void) nextPage: (NSTimer *)timer{

    // 加载图片
    [self loadImage];

    // 重新设置 scrollView 的偏移
    CGFloat scrollViewW = self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(2 * scrollViewW, 0) animated:NO];

    // 设置 pageControl 的 页码
    self.pageContrl.currentPage = self.currentIndex % self.imageNameArr.count;

    NSLog(@"---nextPage");
}

#pragma mark - UIScrollView 的代理方法
// 开始拖拽的时候
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 停止定时器
    [self stopTimer];

    // 加载图片
    [self loadImage];

    // 重新设置 scrollView 的偏移
    CGFloat scrollViewW = self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(1 * scrollViewW, 0) animated:NO];

    // 设置 pageControl 的页码
    self.pageContrl.currentPage = self.currentIndex - 1;

}

// 停止拖拽的时候
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // 开启定时器
    [self startTimer];
}

// 加载图片
- (void) loadImage{
    // 计算图片下标
    int leftImageIndex, centerImageIndex, rightImageIndex;
    CGFloat scrollViewW = self.scrollView.frame.size.width;

    CGPoint offset = self.scrollView.contentOffset;

    // 只有1张图片
    if (self.imageNameArr.count == 1) {
        leftImageIndex = 1;
        centerImageIndex = 1;
        rightImageIndex = 1;
    }
    // 有2张或以上的图片
    else
    {
        if (offset.x == 2 * scrollViewW) { // 向左拖动
            self.currentIndex++;
        }else if(offset.x == 0){ // 向右拖动
            self.currentIndex--;
        }

        // 推导过程
        /*
        if (self.currentIndex == 4) {
            self.currentIndex = 1;
            leftImageIndex = 3;
            centerImageIndex = 1;
            rightImageIndex = 2;
        }else if(self.currentIndex == 0){
            self.currentIndex = 3;
            leftImageIndex = 2;
            centerImageIndex = 3;
            rightImageIndex = 1;
        }else if(self.currentIndex == 1){
            leftImageIndex = 3;
            centerImageIndex = 1;
            rightImageIndex = 2;
        }else if(self.currentIndex == 3){
            leftImageIndex = 2;
            centerImageIndex = 3;
            rightImageIndex = 1;
        }else{
            leftImageIndex = self.currentIndex -1;
            centerImageIndex = self.currentIndex;
            rightImageIndex = self.currentIndex + 1;
        }
         */

        // 中间 imageView 下标的情况有:
        // 拖动下标超出范围的情况
        if (self.currentIndex == self.imageNameArr.count + 1) {
            self.currentIndex = 1;
            leftImageIndex = self.imageNameArr.count;
            centerImageIndex = self.currentIndex;
            rightImageIndex = self.currentIndex + 1;
        }else if(self.currentIndex == 0){
            self.currentIndex = self.imageNameArr.count;
            leftImageIndex = self.currentIndex - 1;
            centerImageIndex = self.currentIndex;
            rightImageIndex = 1;
        // 位于首位的情况
        }else if(self.currentIndex == 1){
            leftImageIndex = self.imageNameArr.count;
            centerImageIndex = self.currentIndex;
            rightImageIndex = self.currentIndex + 1;
        }else if(self.currentIndex == self.imageNameArr.count){
            leftImageIndex = self.currentIndex - 1;
            centerImageIndex = self.currentIndex;
            rightImageIndex = 1;
        // 一般情况
        }else{
            leftImageIndex = self.currentIndex -1;
            centerImageIndex = self.currentIndex;
            rightImageIndex = self.currentIndex + 1;
        }
    }

    //NSLog(@"left = %i, center = %i, right = %i", leftImageIndex, centerImageIndex, rightImageIndex);

    // 给各个 imageView 设置图片
    self.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%02d", PrefixImageName, leftImageIndex]];
    self.centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%02d", PrefixImageName, centerImageIndex]];
    self.rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%02d", PrefixImageName, rightImageIndex]];

    //NSLog(@"%i", self.currentIndex);
    NSLog(@"---loadImage");

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 加载图片
    [self loadImage];

    // 重新设置 scrollView 的偏移
    CGFloat scrollViewW = self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(1 * scrollViewW, 0) animated:NO];

    // 设置 pageControl 的页码
    self.pageContrl.currentPage = self.currentIndex - 1;

     NSLog(@"---scrollViewDidEndDecelerating");
}

@end
