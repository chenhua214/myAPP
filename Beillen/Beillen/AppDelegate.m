//
//  AppDelegate.m
//  Beillen
//
//  Created by chenyi on 2026/1/26.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 1. 获取单例实例
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    // 4. (可选) 启用自动工具栏 (包含上一项/下一项/完成按钮)
    keyboardManager.enableAutoToolbar = YES;
    keyboardManager.enable = YES;                          // 全局启用
    keyboardManager.shouldResignOnTouchOutside = YES;      // 点击背景收起键盘
    keyboardManager.keyboardDistanceFromTextField = 10.0;  // 输入框距离键盘顶部的间距
        
    return YES;
  
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
