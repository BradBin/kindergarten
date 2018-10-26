//
//  YBCustomResfreshFooter.m
//  AppDemo
//
//  Created by Macbook Pro 15.4  on 2018/4/22.
//  Copyright © 2018年 Macbook Pro 15.4 . All rights reserved.
//

#import "YBCustomResfreshFooter.h"




@interface UIImageView(Animation)

- (CABasicAnimation *)rotationAnimation;
- (void)stopRotationAnimation;


@end


@implementation UIImageView(Animation)


- (CABasicAnimation *)rotationAnimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    return rotationAnimation;
}


- (void)stopRotationAnimation {
    
    if ([self.layer animationForKey:@"rotationAnimation"]) {
        [self.layer removeAnimationForKey:@"rotationAnimation"];
    }
}

@end



@interface YBCustomResfreshFooter()

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *loadingImgV;

@end

@implementation YBCustomResfreshFooter



#pragma mark - 重写初始化配置文件
- (void)prepare{
    
    [super prepare];
    self.mj_h = 50.0;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
//     self.automaticallyHidden = true;
#pragma clang diagnostic pop
    self.stateLabel.hidden = true;
    self.automaticallyChangeAlpha = true;
    [self addSubview:self.label];
    [self addSubview:self.loadingImgV];
//     [self setImages:@[[UIImage imageNamed:@"placer_noMore"]] forState:MJRefreshStateNoMoreData];

}


#pragma mark - 设置子控件的位置和尺寸
-(void)placeSubviews{
    [super placeSubviews];
    self.label.frame = self.bounds;
    self.loadingImgV.bounds = CGRectMake(0, 0, 16, 16);
    self.loadingImgV.center = CGPointMake(self.mj_w * 0.5 + 80, self.mj_h * 0.5);
//    if (self.state == MJRefreshStateNoMoreData) {
//        self.gifView.contentMode = UIViewContentModeScaleAspectFit;
//        self.gifView.image = [UIImage imageNamed:@"placer_noMore"];
//    }
}



#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    
    [super scrollViewPanStateDidChange:change];
}


#pragma mark -监听控件的刷新状态
-(void)setState:(MJRefreshState)state{
    
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"Pull up to load more";
            self.loadingImgV.hidden = NO;
            [self.loadingImgV stopRotationAnimation];
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"Loading...";
            self.loadingImgV.hidden = NO;
            [self.loadingImgV rotationAnimation];
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"No more data";
            self.loadingImgV.hidden = YES;
            [self.loadingImgV stopRotationAnimation];
            break;
        default:
            break;
    }
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





-(UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor lightGrayColor];
        _label.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:14.5];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}



-(UIImageView *)loadingImgV{
    if (_loadingImgV == nil) {
        _loadingImgV = [[UIImageView alloc] init];
        _loadingImgV.contentMode = UIViewContentModeScaleAspectFit;
        _loadingImgV.image = [UIImage imageNamed:@"loading_16x16.png"];
    }
    return _loadingImgV;
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
