//
//  AppToolHeader.h
//  AppTool
//
//  Created by Macbook Pro 15.4  on 2018/10/2.
//  Copyright © 2018年 Macbook Pro 15.4 . All rights reserved.
//

#ifndef AppToolHeader_h
#define AppToolHeader_h


#define HN_MIAN_STYLE_COLOR [UIColor colorWithRed:0.97 green:0.35 blue:0.35 alpha:1.0]
#define HN_TABBERBAR_GRAY_COLOR [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1.0f]
#define HN_MIAN_GRAY_Color [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1]
#define HN_WEAK_SELF __weak typeof(self) wself = self;

#define HN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define HN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define HN_NAVIGATION_BAR_HEIGHT ([UIScreen mainScreen].bounds.size.height == 812 ? 88 :64)
#define HN_STATUS_BAR_HEIGHT ([UIScreen mainScreen].bounds.size.height == 812 ? 44 : 20)
#define HN_TABBER_BAR_HEIGHT ([UIScreen mainScreen].bounds.size.height == 812 ? 83 : 49)
#define HN_BOTTOM_MARGIN ([UIScreen mainScreen].bounds.size.height == 812 ? 34 : 0)

#define HN_ASYN_GET_MAIN(...)  dispatch_async(dispatch_get_main_queue(), ^{ \
__VA_ARGS__;\
});



#endif /* AppToolHeader_h */
