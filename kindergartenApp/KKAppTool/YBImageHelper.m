//
//  YBImageHelper.m
//  AppTool
//
//  Created by Macbook Pro 15.4  on 2018/10/6.
//  Copyright © 2018年 Macbook Pro 15.4 . All rights reserved.
//

#import "YBImageHelper.h"

@implementation YBImageHelper


+ (YYWebImageManager *)avatarImageManager {
    static YYWebImageManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[UIApplication sharedApplication].cachesPath stringByAppendingPathComponent:@"weibo.avatar"];
        YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
        _manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
        _manager.sharedTransformBlock = ^(UIImage *image, NSURL *url) {
            if (!image) return image;
            return [image imageByRoundCornerRadius:100]; // a large value
        };
    });
    return _manager;
}

@end
