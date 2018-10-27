//
//  YBDiskCacheHelper.h
//  AppTool
//
//  Created by Macbook Pro 15.4  on 2018/9/26.
//  Copyright © 2018年 Macbook Pro 15.4 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBDiskCacheHelper : NSObject


@property (nonatomic , strong)YYDiskCache *diskCache;

+ (instancetype)defaultHelper;

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;

- ( id<NSCoding>)objectForKey:(NSString *)key;

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(void))block;

- (void)removeObjectForKey:(NSString *)key;

- (void)setMaxArrayCount:(NSInteger)maxCount forKey:(NSString *)key;

- (void)removeMaxCountForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
