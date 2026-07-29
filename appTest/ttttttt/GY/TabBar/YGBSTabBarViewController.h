//
//  YGBSTabBarViewController.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// tabr控制器
@interface YGBSTabBarViewController : UITabBarController
@property(nonatomic,assign,readonly) NSInteger type_controller;
/// 是否显示中间突出按钮
@property(nonatomic,assign) BOOL type_controllerWithCentreBtn;
+ (instancetype)TabBarViewControllerWithType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
