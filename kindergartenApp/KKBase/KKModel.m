//
//  KKModel.m
//  kindergartenApp
//
//  Created by 尤彬 on 2018/10/26.
//  Copyright © 2018 youbin. All rights reserved.
//

#import "KKModel.h"
#import <objc/runtime.h>

@implementation KKModel


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        NSString *propertyValue = [self valueForKeyPath:propertyName];
        [aCoder encodeObject:propertyValue forKey:propertyName];
    }
    free(properties);
}



- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            const char *name = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:name];
            NSString *propertyValue = [aDecoder decodeObjectForKey:propertyName];
            [self setValue:propertyValue forKey:propertyName];
        }
        free(properties);
    }
    return self;
}



@end
