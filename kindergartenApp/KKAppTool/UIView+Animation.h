//
//  UIView+Animation.h
//  AppTool
//
//  Created by Macbook Pro 15.4  on 2018/10/3.
//  Copyright © 2018年 Macbook Pro 15.4 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Animation)

- (CABasicAnimation *)rotationAnimation;
- (void)stopRotationAnimation;

@end

NS_ASSUME_NONNULL_END
