//
//  YGBSTabBarViewController.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/15.
//

#import "YGBSTabBarViewController.h"
#import "YGNavigationController.h"
#import "YGHomeViewController.h"
#import "YGMineViewController.h"
#import "YGMineViewController.h"
#import "YGBSCurveTabBar.h"

@interface YGBSTabBarViewController ()<UITabBarControllerDelegate,YGBSCurveTabBarDelegate>
@property(nonatomic,assign) NSInteger type_controller;
@property(nonatomic,assign) BOOL firstLayout;
@end

@implementation YGBSTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [self viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
    
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.selectedViewController endAppearanceTransition];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.selectedViewController endAppearanceTransition];
//    [self monitorNetWorkStatus];
//    [self refreshImageIfNeeded];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    ///调用以下两个方法,_UIBarBackground子视图才会存在
    [self.tabBar setNeedsLayout];
    [self.tabBar layoutIfNeeded];
    if (self.firstLayout) {
        return;
    }
    [self.tabBar tabBarBackgroundColor:[UIColor whiteColor] customSeparatorColor:[UIColor bs_colorFromARGB:@"#000000" alpha:0.05] height:0.5f];
    self.firstLayout = YES;
}

#pragma mark- Public methods

+ (instancetype)TabBarViewControllerWithType:(NSInteger)type{
    YGBSTabBarViewController *tabBarVC = [YGBSTabBarViewController new];
    tabBarVC.type_controller = type;
    [tabBarVC setup];
    return tabBarVC;
}

#pragma mark- setup

- (void)setup{
//    [self addNotifications];
    self.type_controllerWithCentreBtn = NO;
   
       
            
            // 首页
    YGHomeViewController *homeVC = [[YGHomeViewController alloc]init];
    [self setViewController:homeVC title:@"首页" image:@"tab_home_nor" selectImage:@"tab_home_sld" tag:1000];
            //   我的
    YGMineViewController *storeVC = [[YGMineViewController alloc]init];
    [self setViewController:storeVC title:@"我的" image:@"tab_mine_nor" selectImage:@"tab_mine_sld" tag:1001];
        
    [self setupTabBar];
    self.delegate = self;
    [self fixBug];
}

- (void)setupTabBar{
//    if (self.type_controller == 0) {
//        [self setValue:[[YGBSCurveTabBar alloc] init] forKey:@"tabBar"];
//        [(YGBSCurveTabBar *)self.tabBar setTranslucent:NO];
//        [(YGBSCurveTabBar *)self.tabBar setCurveDelegate:self];
//        [(YGBSCurveTabBar *)self.tabBar reloadData];
//    }
}

- (void)isBSCurveTabBar {
    if ([self.tabBar isKindOfClass:YGBSCurveTabBar.class ]) {
        [(YGBSCurveTabBar *)self.tabBar upMallButtonIsSelect];
    }
}

- (void)fixBug{
    
    /// 修改 tabBar  字体、选中颜色、默认颜色
    [self setTabBarItemFontOfSize:10 stateSelectedColor:[UIColor bs_colorFromARGB:@"#888888"] stateNormalColor:[UIColor bs_colorFromARGB:@"#B6B6B7"] ];
}

- (void)setTabBarItemFontOfSize:(CGFloat)fontsize stateSelectedColor:(UIColor*) selectedColor stateNormalColor:(UIColor*) normalColor {
    UITabBarItem *item = [UITabBarItem appearance];
    item.titlePositionAdjustment = UIOffsetMake(0, -2);
    if (@available(iOS 10.0, *)) {
        // iOS 10以上
        self.tabBar.tintColor = selectedColor;
        self.tabBar.unselectedItemTintColor = normalColor;
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont bs_semiboldFontWithFontSize:fontsize]} forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont bs_semiboldFontWithFontSize:fontsize]} forState:UIControlStateNormal];
    } else {
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont bs_semiboldFontWithFontSize:fontsize], NSForegroundColorAttributeName:normalColor} forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont bs_semiboldFontWithFontSize:fontsize], NSForegroundColorAttributeName:selectedColor} forState:UIControlStateNormal];
    }
}

#pragma mark - 添加子控制器
- (void)setViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage tag:(NSInteger)tag {
    vc.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.tag = tag;
    YGNavigationController *nav = [[YGNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}


@end
