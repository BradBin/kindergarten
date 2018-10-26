//
//  YBRefreshGifHeader.m
//  AppTool
//
//  Created by Macbook Pro 15.4  on 2018/10/3.
//  Copyright © 2018年 Macbook Pro 15.4 . All rights reserved.
//

#import "YBRefreshGifHeader.h"

#define HNRefreshStateRefreshingImagesCount 16

@interface YBRefreshGifHeader()

@property (strong, nonatomic) UILabel *label;

@end

@implementation YBRefreshGifHeader

-(UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor lightGrayColor];
        _label.font = [UIFont boldSystemFontOfSize:10];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

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
    self.label.frame = CGRectMake(0, self.mj_h - 15, self.mj_w, 15);
    self.gifView.frame = CGRectMake((self.mj_w - 25) / 2.0, self.mj_h - 45, 25, 25);
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"下拉刷新";
            break;
        case MJRefreshStatePulling:
            self.label.text = @"松开刷新";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"加载中...";
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
    self.label.textColor = [UIColor lightGrayColor];
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
