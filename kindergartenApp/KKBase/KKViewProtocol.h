//
//  KKViewProtocol.h
//  kindergartenApp
//
//  Created by 尤彬 on 2018/10/25.
//  Copyright © 2018 youbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKViewModelProtocol;

@protocol KKViewProtocol <NSObject>

@optional

- (instancetype) initWithViewModel:(id<KKViewModelProtocol>)viewModel;



/**
 绑定ViewModel
 */
- (void) kk_bindViewModel;



/**
 创建视图
 */
- (void) kk_setupView;


/**
 键盘失能
 */
- (void) kk_addReturnKeyBoard;


@end
