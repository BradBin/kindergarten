//
//  KKViewModel.m
//  kindergartenApp
//
//  Created by 尤彬 on 2018/10/25.
//  Copyright © 2018 youbin. All rights reserved.
//

#import "KKViewModel.h"

@implementation KKViewModel

/**
 重写alloc的本质是调用allocWithZone方法来为对象分配内存地址
 备注:单例类的核心就为了确保当前访问的对象内存地址是固定的并且可以掌握周期
 **/


+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    KKViewModel *viewModel = [super allocWithZone:zone];
    if (viewModel) {
        [viewModel kk_initialize];
    }
    return viewModel;
}


-(instancetype)initWithModel:(id)model{
    self = [super init];
    return self;
}


-(void)kk_initialize{}

@end
