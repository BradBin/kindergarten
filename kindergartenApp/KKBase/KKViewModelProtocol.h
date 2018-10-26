//
//  KKViewModelProtocol.h
//  kindergartenApp
//
//  Created by 尤彬 on 2018/10/25.
//  Copyright © 2018 youbin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,KKRefreshDataStatus) {
    
    KKRefreshDataStatusNoData = 1<<0,   //暂无数据
    KKRefreshDataStatusRefreshUI,       //刷新界面
    KKRefreshDataStatusRefreshError,    //错误状态
    
    KKRefreshDataStatusFooterMoreData,  //上拉加载_还有数据
    KKRefreshDataStatusFooterNoMoreData,//上拉加载_没有数据了
    KKRefreshDataStatusHeaderMoreData,  //下拉刷新_有数据
    KKRefreshDataStatusHeaderNoMoreData //下拉刷洗_没有数据
};

@protocol KKViewModelProtocol <NSObject>

@optional

- (instancetype) initWithModel:(id) model;

/**
 初始化
 */
- (void) kk_initialize;


@end
