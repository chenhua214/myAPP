//
//  YGTabBarViewController.m
//  Beillen
//
//  Created by chenyi on 2026/9/26.
//

#import "YGTabBarViewController.h"
#import "YGHomeViewController.h"
#import "YGMineViewController.h"
#import "YGNavigationController.h"
#import "YLCustomTabBar.h"

@interface YGTabBarViewController ()<CustomFloatingTabBarDelegate>
@property (nonatomic, strong) YLCustomTabBar *customTabBar;
@end

@implementation YGTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

#pragma mark- setup

-(void)clickBtn {
//    [self setup];
}

- (void)setup{
    // 首页
    // 1. 隐藏系统原生 TabBar
    self.tabBar.tintColor = [UIColor clearColor];
    self.tabBar.unselectedItemTintColor = [UIColor clearColor];
    self.tabBar.barTintColor = [UIColor clearColor];
    // 2. 初始化自定义 TabBar
    // 假设屏幕宽 393 (iPhone 14 Pro)，高度 60，距离底部 20 (悬浮效果)
    CGFloat tabBarHeight = 60;
    CGFloat sp_left = 24;
    CGFloat width = self.view.bounds.size.width - sp_left*2;
    CGFloat y = 0;
    self.customTabBar.frame = CGRectMake(sp_left, y, width, tabBarHeight);
    self.customTabBar = [[YLCustomTabBar alloc] initWithFrame:CGRectMake(sp_left, y, width, tabBarHeight)];
    self.customTabBar.delegate = self;
       
    // 3. 配置 Tab 项
    NSArray *titles = @[@"首页",@"我的"];
    NSArray *normals = @[@"tab_home_nor", @"tab_mine_nor"];
    NSArray *selects = @[@"tab_home_sld",@"tab_mine_sld"];
    [self.customTabBar setupItemsWithTitles:titles normalImages:normals selectedImages:selects];
   
    // 4. 添加到视图层级最高处
    [self.tabBar addSubview:self.customTabBar];
       // 5. 设置子控制器
    YGHomeViewController *vc1 = [[YGHomeViewController alloc] init];
    vc1.view.backgroundColor = [UIColor whiteColor];
       
    YGMineViewController *vc3 = [[YGMineViewController alloc] init];
    vc3.view.backgroundColor = [UIColor whiteColor];
       
    YGNavigationController *nav1 = [[YGNavigationController alloc]initWithRootViewController:vc1];
    YGNavigationController *nav3 = [[YGNavigationController alloc]initWithRootViewController:vc3];
    self.viewControllers = @[nav1, nav3];
}


#pragma mark - CustomFloatingTabBarDelegate

- (void)floatingTabBarDidSelectIndex:(NSInteger)index {
    self.selectedIndex = index;
}

// 重要：处理旋转或布局变化时，更新自定义 TabBar 的位置
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 重新计算位置，确保始终悬浮在底部上方
    CGFloat tabBarHeight = 60;
    CGFloat sp_left = 24;
    CGFloat width = self.view.bounds.size.width - sp_left*2;
    CGFloat y = 0;
    self.customTabBar.frame = CGRectMake(sp_left, y, width, tabBarHeight);
    [self.tabBar bringSubviewToFront:self.customTabBar];
}



#pragma mark - 添加子控制器
- (void)setViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage tag:(NSInteger)tag {
    vc.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.tag = tag;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

@end
