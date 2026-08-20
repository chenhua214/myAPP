//
//  BSBaseTabBarRootController.h
//  Beillen
//
//  Created by chenyi on 2026/8/20.
//

#import "YGTableViewController.h"
#import "BSHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BSBaseTabBarRootController : YGTableViewController
@property (nonatomic, strong) BSHomeDeviceModel *model;
/// 作为子视图Tabbar的根视图时使用
@property (nonatomic, assign) BOOL isTabBarRootVC;

@property (nonatomic, strong) UIView *contentTextView;

/// 设备唯一标识
@property (nonatomic, copy) NSString *identifier;

- (void)setTabBarItemTitle:(NSString * __nullable)title;
@end

NS_ASSUME_NONNULL_END
