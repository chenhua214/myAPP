//
//  YGBSCurveTabBar.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YGBSCurveTabBar;

@protocol YGBSCurveTabBarDelegate <NSObject>
@optional
/// 返回NSNotFound代表无商城按钮,默认无商城按钮
- (NSInteger)indexOfMallButton;

/// 返回控制器的个数
- (NSInteger)numberOfControllers;

/// 应该选中index所在的控制器
- (void)tabBar:(YGBSCurveTabBar *)tabBar didSelectedItemAtIndex:(NSInteger)index;

/// 商城按钮被点击了,可在此方法中处理点击事件
- (void)didMallButtonPressed;
/// 商城按钮被点击了,可在此方法中处理点击事件
//- (void)didMallButtonWithBtn:(BSTabBarButton*)button;
@end

@interface YGBSCurveTabBar : UITabBar
@property(nullable, nonatomic, weak) id<YGBSCurveTabBarDelegate> curveDelegate;
- (void)reloadData;
- (void)refreshImageIfNeeded;
- (CGRect)itemFrameAtIndex:(NSInteger)index;
- (void)upMallButtonIsSelect;
/// 切换APP语言后更新商城文案
- (void)updateMallTexExchangeLanguage;
@end

NS_ASSUME_NONNULL_END
