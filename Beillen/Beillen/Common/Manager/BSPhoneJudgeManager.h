//
//  ZLJPhoneJudgeManager.h
//  Beillen
//
//  Created by lmh on 2020/4/1.
//  Copyright © 2020 Beillen.All rights reserved.
//  用于计算 kDevice_Is_iPhoneXSeries  kDeviceSafeAreaBottom  kDeviceStatuBarHeight  kDeviceNavigationBarHeight   kDeviceNaviAndStatusHeight

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSPhoneJudgeManager : NSObject

@property (nonatomic, assign) BOOL iPhoneXSeries;
// lq2
@property (assign, nonatomic) UIEdgeInsets safeInset;

// lq2 default 高度根据机型高度判断 20 或者 44
@property (assign, nonatomic) CGRect statusBarFrame;

// lq2 default 高度44
@property (assign, nonatomic) CGRect navigationBarFrame;

/**
@brief 实例

@return 实例
*/
+ (instancetype)shareManager;

/**
 @brief 判断机型 注意： 调用放到 创建window 之后才准确
 */
- (void)executePhoneJudge;

// lq2 在mainTab中去计算 statusBar的高度
- (void)executeStatusBar;

// lq2 计算navigationBar的高度
- (void)executeNavigationBarWithNavigationController:(UINavigationController *)navVC;

- (CGFloat)getStatusBarHight;

@end

NS_ASSUME_NONNULL_END
