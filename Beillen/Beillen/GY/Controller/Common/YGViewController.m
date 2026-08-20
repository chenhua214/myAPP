//
//  YGViewController.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/15.
//

#import "YGViewController.h"

@interface YGViewController ()<BSRefreshIpadScreenProtocol>
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation YGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.bs_shadowHidden = YES;
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self addBackButtonIfNeeded];
    self.view.backgroundColor = self.bs_backgroundColor = UIColor.whiteColor;
    [self updateBackImgAndTitleFonts];
    NSLog(@"%s - %@",__func__,NSStringFromClass(self.class));
    [self addRefreshIpadScreenSizeNotification];
    /////   b版本计划
}

- (void)dealloc{
//    AppLog(@"%@----------dealloc",NSStringFromClass([self class]));
    [self removeRefreshIpadScreenSizeNotification];
}


- (void)addBackButtonIfNeeded{
//    if (self.navigationController.viewControllers.count > 1) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
//    }else{
//        self.navigationItem.leftBarButtonItem = nil;
//        self.navigationItem.hidesBackButton = YES;
//    }
}

#pragma mark- Public methods

- (void)requestShoppingList
{
 
}

- (void)push2HelpFeedbackViewWithModel:(NSString *)model categoryId:(NSInteger)categoryId{
 
}

#pragma mark- Action

- (void)onBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToMineDeviceViewControllerIfNeeded{
    [self pop2ViewControllerWithName:@"BSMineDeviceViewController"];
}

- (void)pop2ViewControllerWithName:(NSString *)controllerName{
    if (!controllerName || controllerName.length == 0) {
        NSLog(@"参数错误，请传入有效的参数");
        return;
    }
    NSArray<UIViewController *> *viewControllers = self.navigationController.viewControllers;
    if (!viewControllers || viewControllers.count == 0) {
        return;
    }
    __block UIViewController *targetVC = nil;
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(controllerName)]) {
            targetVC = obj;
            *stop = YES;
        }
    }];
    if (!targetVC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    UITabBarController *tabBarVC = (UITabBarController *)targetVC;
    if ([tabBarVC isKindOfClass:UITabBarController.class] && [tabBarVC respondsToSelector:@selector(setSelectedIndex:)]){
        //默认选中第一个Tab
        [tabBarVC setSelectedIndex:0];
    }
    [self.navigationController popToViewController:targetVC animated:YES];
}

- (void)updateBackBtnImage:(NSString *)image imageEdgeInsets:(UIEdgeInsets)edgeInsets {
    if (image.isEnable) {
        [self.backBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    [self.backBtn setImageEdgeInsets:edgeInsets];
}

- (void)push2ProductManuaVCWithURL:(NSString *)urlString{
    if (!urlString) { return; }
//    BSWashWebViewController *webVC = [BSWashWebViewController new];
//    webVC.webType = BSWashWebTypeProductManua;
//    webVC.separateUrlStr = urlString;
//    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)removeViewControllerName:(NSString *)className{
    NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
    if(viewControllers.count == 0){ return; }
    __block BOOL found = NO;
    //反序查找最近的一个相同类名的控制器
    [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse
                                                                usingBlock:^(UIViewController* baseVC, NSUInteger idx, BOOL * _Nonnull stop) {
        if([NSStringFromClass(baseVC.class) isEqualToString:className]){
            found = YES;
            [viewControllers removeObject:baseVC];
            *stop = YES;
        }
    }];
    //如果未找到,直接返回
    if(!found){ return; }
    //重新设置导航栈
    self.navigationController.viewControllers = viewControllers;
}

- (void)hiddenBackBtn:(BOOL)hidden{
//    self.backBtn.hidden = hidden;
}

-(CGFloat)topPadding{
    CGFloat topPaddingNum = self.view.safeAreaInsets.top;
    return topPaddingNum;
}

/// 更新返回按钮图片以及字体颜色为粗体
- (void)updateBackImgAndTitleFonts {
    [self updateBackBtnImage:@"nav_back24x24" imageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.bs_titleFont = bsFontMedium(20);
}

#pragma mark- Setters && Getters

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton bs_defaultBackBtn];
        [_backBtn addTarget:self action:@selector(onBackAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

#pragma mark - ipad
-(void)refreshIpadScreenSizeAction:(CGSize)size{
    NSLog(@"%@-%s-width: %f, height: %f",NSStringFromClass(self.class), __func__, size.width, size.height);
}

@end
