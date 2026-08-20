//
//  ZLJPhoneJudgeManager.m
//  Beillen
//
//  Created by lmh on 2020/4/1.
//  Copyright © 2020 Beillen.All rights reserved.
//

#import "BSPhoneJudgeManager.h"

@interface BSPhoneJudgeManager ()

@end

@implementation BSPhoneJudgeManager

+ (instancetype)shareManager {
    static BSPhoneJudgeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BSPhoneJudgeManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self executePhoneJudge];
        // 设置默认值
        self.navigationBarFrame = CGRectMake(0, 0, kSCREEN_WIDTH, 44);
        
    }
    return self;
}

- (void)executePhoneJudge {
    self.iPhoneXSeries = [self getIsIPhoneXSeries];
    // 设置默认值
    self.statusBarFrame = CGRectMake(0, 0, kSCREEN_WIDTH, self.iPhoneXSeries ? 44.0 : 20.0);
}

- (void)executeStatusBar {
    if(![UIApplication sharedApplication].statusBarHidden) {
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        self.statusBarFrame = statusBarFrame;
    }
}

- (void)executeNavigationBarWithNavigationController:(UINavigationController *)navVC {
    if (!navVC) return;
    self.navigationBarFrame = navVC.navigationBar.frame;
}

- (BOOL)getIsIPhoneXSeries {
    BOOL iPhoneXSeries = NO;
    if (@available(iOS 11.0, *)) {
//        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
        self.safeInset = mainWindow.safeAreaInsets;
    }
    return iPhoneXSeries;
}

- (CGFloat)getStatusBarHight {
   float statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
       UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
       statusBarHeight = statusBarManager.statusBarFrame.size.height;
   }
   else {
       statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
   }
   return statusBarHeight;
}
@end
