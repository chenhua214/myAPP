//
//  BSLanguageTool.m
//  Beillen
//
//  Created by wushuang on 2024/7/23.
//  Copyright © 2024 Beillen.All rights reserved.
//

#import "BSLanguageTool.h"
#import "BSDeviceUtil.h"

static NSBundle *bundle = nil;

@implementation BSLanguageTool

+ (void)initialize
{
    [self setLanguage:[BSDeviceUtil getCurrentLanguage]]; //指定当前语言
}

+ (void)setLanguage:(NSString *)language
{
    NSBundle *tmpBundle = [NSBundle mainBundle];
    NSString *path = [tmpBundle pathForResource:language ofType:@"lproj"];
    if (!path) {
        [self setLanguage:@"en"];
        return;
    }
    NSLog(@"国际化语言 Bundle 资源路径: %@",path);
    bundle = [NSBundle bundleWithPath:path];
}

+ (NSString *)get:(NSString *)key
{
    return [[self class] get:key alter:@""];
}

+ (NSString *)get:(NSString *)key alter:(NSString *)alternate
{
    return [bundle localizedStringForKey:key value:alternate table:nil];
}

@end
