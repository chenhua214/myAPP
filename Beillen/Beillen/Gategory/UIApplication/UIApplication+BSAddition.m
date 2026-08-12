//
//  UIApplication+BSAddition.m
//  BaseusAPP
//
//  Created by skychi on 2021/6/9.
//

#import "UIApplication+BSAddition.h"

@implementation UIApplication (BSAddition)

+ (void)OpenURLWithURLString:(NSString *)URLString{
    if (!URLString.isEnable) {
        NSLog(@"URLString is not empty");
        return;
    }
    NSURL *openURL = [NSURL URLWithString:URLString];
    if(![[UIApplication sharedApplication] canOpenURL:openURL]){
        NSLog(@"Can Not Open URL: %@",URLString);
        return;
    }
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:openURL
                                           options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(NO)}
                                 completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:openURL];
    }
}

@end
