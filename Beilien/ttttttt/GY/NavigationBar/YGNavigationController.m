//
//  YGNavigationController.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/16.
//

#import "YGNavigationController.h"
#import "YGFakeNavigationBar.h"
#import "UIViewController+YGNavigationBar.h"

@interface YGNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    BOOL _ispushView ;   // 防止重复点击，多次跳转加载同一个界面
}
@property (nonatomic, strong) YGFakeNavigationBar *fakeBar;
@property (nonatomic, strong) YGFakeNavigationBar *fromFakeBar;
@property (nonatomic, strong) YGFakeNavigationBar *toFakeBar;
@property (nonatomic, strong) UIView *fakeSuperView;
@property (nonatomic, weak  ) UIViewController *popingVC;
@end

@implementation YGNavigationController

- (void)dealloc
{
    @try {
        [self.fakeSuperView removeObserver:self forKeyPath:@"frame"];
    } @catch (NSException *exception) { }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(handleInteractivePopGesture:)];
    [self setupNavigationbar];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated{
     if (@available(iOS 16.1, *)) {
         //系统Bug,详见 https://developer.apple.com/forums/thread/714679
         [self.navigationBar setNeedsLayout];
         [self.navigationBar layoutIfNeeded];
     }
     [super setNavigationBarHidden:hidden animated:animated];
}

- (void)setupNavigationbar
{
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    [self setupFakeSubviews];
}

- (void)setupFakeSubviews
{
    if (!self.fakeSuperView) return;
    if (self.fakeBar.superview == nil) {
        [self.fakeSuperView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        [self.fakeSuperView insertSubview:self.fakeBar atIndex:0];
    }
}

- (void)layoutFakeSubviews
{
    if (!self.fakeSuperView) return;
    self.fakeBar.frame = self.fakeSuperView.bounds;
    [self.fakeBar setNeedsLayout];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (self.transitionCoordinator) {
        UIViewController *fromVC = [self.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        if (!fromVC) return;
        if (fromVC == self.popingVC) {
            [self bs_updateNavigationBarForController:fromVC];
        }
    } else {
        if (!self.topViewController) return;
        [self bs_updateNavigationBarForController:self.topViewController];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutFakeSubviews];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    self.popingVC = self.topViewController;
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    if (self.topViewController) {
        [self bs_updateNavigationBarTintForController:self.topViewController ignoreTintColor:YES];
    }
    return viewController;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    if (animated && self.viewControllers.count > 1 && self.topViewController) {
        self.topViewController.hidesBottomBarWhenPushed = NO;
    }
    self.popingVC = self.topViewController;
    NSArray *vcArray = [super popToRootViewControllerAnimated:animated];
    if (self.topViewController) {
        [self bs_updateNavigationBarTintForController:self.topViewController ignoreTintColor:YES];
    }
    return vcArray;
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.popingVC = self.topViewController;
    NSArray *vcArray = [super popToViewController:viewController animated:animated];
    if (self.topViewController) {
        [self bs_updateNavigationBarTintForController:self.topViewController ignoreTintColor:YES];
    }
    return vcArray;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (_ispushView) return;
    _ispushView = YES;
    if (self.childViewControllers.count > 0) { // 如果现在push的不是栈底控制器（最先push进来的那个控制器）
        viewController.hidesBottomBarWhenPushed = YES;
        // 就有滑动返回功能
        // self.interactivePopGestureRecognizer.delegate = nil;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

// MARK:- UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.transitionCoordinator) {
        [self showViewController:viewController coordinator:self.transitionCoordinator];
    } else {
        if (!animated && self.viewControllers.count > 1) {
            UIViewController *lastButOneVC = self.viewControllers[self.viewControllers.count-2];
            [self showTempFakeBarFromVC:lastButOneVC toVC:viewController];
            return;
        }
        [self bs_updateNavigationBarForController:viewController];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    _ispushView = NO ;
    if (!animated) {
        [self bs_updateNavigationBarForController:viewController];
        [self cleraTempFakebar];
    }
    self.popingVC = nil;
}

// MARK:- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    if (self.topViewController) {
        return self.topViewController.bs_enablePopGesture;
    }
    return YES;
}


// MARK:- Targets

- (void)handleInteractivePopGesture:(UIScreenEdgePanGestureRecognizer *)gesture
{
    if (!self.transitionCoordinator) return;
    UIViewController *fromVC = [self.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!fromVC || !toVC) return;
    if (gesture.state == UIGestureRecognizerStateChanged) {
        self.navigationBar.tintColor = [self averageFromColor:fromVC.bs_tintColor toColor:toVC.bs_tintColor percent:self.transitionCoordinator.percentComplete];
    }
}


// MARK:- Tools

- (UIColor *)averageFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent
{
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    CGFloat red = fromRed + (toRed - fromRed) * percent;
    CGFloat green = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat blue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat alpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)showViewController:(UIViewController *)vc coordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    UIViewController *fromVC = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!fromVC || !toVC) return;
    [self resetButtonLabelsInView:self.navigationBar];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self bs_updateNavigationBarTintForController:vc ignoreTintColor:context.isInteractive];
        if (vc == toVC) {
            [self showTempFakeBarFromVC:fromVC toVC:toVC];
        } else {
            [self bs_updateNavigationBarShadowForController:vc];
            [self bs_updateNavigationBarBackgroundColorForController:vc];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (context.isCancelled) {
            [self bs_updateNavigationBarForController:fromVC];
        } else {
            [self bs_updateNavigationBarForController:vc];
        }
        if (vc == toVC) {
            [self cleraTempFakebar];
        }
    }];
}

- (void)resetButtonLabelsInView:(UIView *)bView
{
    NSString *viewClassName = [[bView.classForCoder description] stringByReplacingOccurrencesOfString:@"_" withString:@""];
    if ([viewClassName isEqual:@"UIButtonLabel"]) {
        bView.alpha = 1;
    } else {
        if (bView.subviews.count > 0) {
            for (UIView *subview in bView.subviews) {
                [self resetButtonLabelsInView:subview];
            }
        }
    }
}

- (void)showTempFakeBarFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC
{
    [UIView setAnimationsEnabled:NO];
    self.fakeBar.alpha = 0;
    // From
    [fromVC.view addSubview: self.fromFakeBar];
    self.fromFakeBar.frame = [self fakebarFrameForController:fromVC];
    [self.fromFakeBar setNeedsLayout];
    [self.fromFakeBar bs_updateFakeBarBackGroundForViewController:fromVC];
    [self.fromFakeBar bs_updateFakeBarShadowForViewController:fromVC];
    // To
    [toVC.view addSubview:self.toFakeBar];
    self.toFakeBar.frame = [self fakebarFrameForController:toVC];
    [self.toFakeBar setNeedsLayout];
    [self.toFakeBar bs_updateFakeBarBackGroundForViewController:toVC];
    [self.toFakeBar bs_updateFakeBarShadowForViewController:toVC];
    [UIView setAnimationsEnabled:YES];
}

- (void)cleraTempFakebar
{
    self.fakeBar.alpha = 1;
    [self.fromFakeBar removeFromSuperview];
    [self.toFakeBar removeFromSuperview];
}

- (CGRect)fakebarFrameForController:(UIViewController *)vc
{
    if (self.fakeSuperView) {
        CGRect frame = [self.navigationBar convertRect:self.fakeSuperView.frame toView:vc.view];
        frame.origin.x = vc.view.frame.origin.x;
        return frame;
    }
    return self.navigationBar.frame;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqual:@"frame"]) {
        [self layoutFakeSubviews];
    }
}

- (void)bs_updateNavigationBarForController:(UIViewController *)vc
{
    [self setupFakeSubviews];
    [self bs_updateNavigationBarTintForController:vc ignoreTintColor:NO];
    [self bs_updateNavigationBarBackgroundColorForController:vc];
    [self bs_updateNavigationBarShadowForController:vc];
}

- (void)bs_updateNavigationBarTintForController:(UIViewController *)vc ignoreTintColor:(BOOL)ignoreTintColor
{
    if (vc != self.topViewController) return;
    [UIView setAnimationsEnabled:NO];
    self.navigationBar.barStyle = vc.bs_barStyle;
    NSDictionary *titleTextAttribute = @{
        NSForegroundColorAttributeName:vc.bs_titleColor,
        NSFontAttributeName:vc.bs_titleFont,
    };
    self.navigationBar.titleTextAttributes = titleTextAttribute;
    if (!ignoreTintColor) {
        self.navigationBar.tintColor = vc.bs_tintColor;
    }
    [UIView setAnimationsEnabled:YES];
}

- (void)bs_updateNavigationBarBackgroundColorForController:(UIViewController *)vc
{
    if (vc != self.topViewController) return;
    [self.fakeBar bs_updateFakeBarBackGroundForViewController:vc];
}

- (void)bs_updateNavigationBarShadowForController:(UIViewController *)vc
{
    if (vc != self.topViewController) return;
    [self.fakeBar bs_updateFakeBarShadowForViewController:vc];
}


// MARK:- Getter

- (YGFakeNavigationBar *)fakeBar {
    if (!_fakeBar) {
        _fakeBar = [[YGFakeNavigationBar alloc] init];
    }
    return _fakeBar;
}

- (YGFakeNavigationBar *)fromFakeBar {
    if (!_fromFakeBar) {
        _fromFakeBar = [[YGFakeNavigationBar alloc] init];
    }
    return _fromFakeBar;
}

- (YGFakeNavigationBar *)toFakeBar {
    if (!_toFakeBar) {
        _toFakeBar = [[YGFakeNavigationBar alloc] init];
    }
    return _toFakeBar;
}

- (UIView *)fakeSuperView {
    return self.navigationBar.subviews.firstObject;
}



@end
