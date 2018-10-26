//
//  YBEmitterHelper.h
//  AppTool
//
//  Created by Macbook Pro 15.4  on 2018/9/26.
//  Copyright © 2018年 Macbook Pro 15.4 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBEmitterHelper : NSObject

// 需要长按手势的View
@property (nonatomic , weak)UIView *addLongPressAnimationView;

+ (instancetype)defaultHelper;
- (void)showEmitterCellsWithImages:(NSArray<UIImage *>*)images withShock:(BOOL)shouldShock onView:(UIView *)view;
+ (NSArray <UIImage *>*)defaultImages;

@end

NS_ASSUME_NONNULL_END
