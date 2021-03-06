//
//  YBCustomRefreshHeader.m
//  AppDemo
//
//  Created by Macbook Pro 15.4  on 2018/4/23.
//  Copyright © 2018年 Macbook Pro 15.4 . All rights reserved.
//

#import "YBCustomRefreshHeader.h"


NSUInteger const HNRefreshStateRefreshingImagesCount = 16;

@interface YBCustomRefreshHeader()



@end

@implementation YBCustomRefreshHeader




#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    // 设置普通状态的动画图片
//    self.mj_h = 50;
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i< HNRefreshStateRefreshingImagesCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%lu", (unsigned long)i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateIdle];
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    // 添加label
    [self addSubview:self.label];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    self.automaticallyChangeAlpha = YES;
    
    self.backgroundColor = UIColor.clearColor;
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.label.frame = CGRectMake(0, self.mj_h - 18, self.mj_w, 15);
    self.gifView.frame = CGRectMake((self.mj_w - 25) / 2.0, self.mj_h - 45, 25, 25);
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"Pull down to refresh";
            break;
        case MJRefreshStatePulling:
            self.label.text = @"Release to refresh";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"Loading...";
            break;
        default:
            break;
    }
}



#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}



#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    // 1.0 0.5 0.0
    // 0.5 0.0 0.5
//    CGFloat red = 1.0 - pullingPercent * 0.5;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:pullingPercent];
}



-(UILabel *)label{
    if (_label == nil) {
        _label = UILabel.alloc.init;
        _label.textColor = [UIColor lightGrayColor];
        _label.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:14.5];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
