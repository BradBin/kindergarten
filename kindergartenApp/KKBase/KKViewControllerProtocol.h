//
//  KKViewControllerProtocol.h
//  kindergartenApp
//
//  Created by 尤彬 on 2018/10/25.
//  Copyright © 2018 youbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKViewModelProtocol;



@protocol KKViewControllerProtocol <NSObject>

@optional

- (instancetype) initWithViewModel:(id<KKViewModelProtocol>)viewModel;

/**
 允许滑动返回
 
 @return 是否允许
 */
- (BOOL)kk_slidingPopEnable;

/**
 默认左上角返回事件，如需指定请重写方法
 */
- (void)popOrDismissAction;

/**
 绑定viewModel
 */
- (void)kk_bindViewModel;

/**
 创建和布局视图
 */
- (void)kk_addSubviews;

/**
 重新布局导航栏
 */
- (void)kk_layoutNavigation;

/**
 获取罪行数据
 */
- (void)kk_getNewData;

/**
 
 */
- (void)recoverKeyboard;

/**
 重新登录
 */
- (void)kk_needRelogin;



@end
