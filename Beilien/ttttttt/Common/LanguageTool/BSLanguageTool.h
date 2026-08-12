//
//  BSLanguageTool.h
//  BaseusAPP
//
//  Created by wushuang on 2024/7/23.
//  Copyright © 2024 Baseus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSLanguageTool : NSObject

/**
 *  使用代码强制使用某一种语言处理
 *  [Language setLanguage:@"de"];
 **/
+ (void)setLanguage:(NSString *)language;

/**
 *  获取国际化语言内容
 **/
+ (NSString *)get:(NSString *)key;

/**
 *  获取国际化语言内容
 **/
+ (NSString *)get:(NSString *)key alter:(NSString *)alternate;

@end

NS_ASSUME_NONNULL_END
