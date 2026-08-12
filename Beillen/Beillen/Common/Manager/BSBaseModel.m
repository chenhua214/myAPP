//
//  BSBaseModel.m
//  BaseusAPP
//
//  Created by  wang on 2021/1/14.
//

#import "BSBaseModel.h"

@implementation BSBaseModel

- (NSString *)description {
    
    // 初始化一个字典
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    // 得到当前classs的所有属性
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        // 循环并用kvc得到每个属性的值
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        if (![BSStringUtil isBlankWithString:name]&& [name isKindOfClass:[NSString class]] ) {
                id value = [self valueForKey:name] ? : @"";  // 默认值为nil字符串
                [dictionary setObject:value forKey:name];
        }
    }
    // 释放
    free(properties);
    // return
    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class], self, dictionary];
}

@end
