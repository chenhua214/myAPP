//
//  NSObject+HUD.m
//  
//
//  Created by apeng on 2018/7/18.
//  Copyright ©  reserved.
//

#import "NSObject+BSHUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "UIWindow+BSExtention.h"

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;
static NSInteger kDefaultHUDViewTag  = 20210902;

@implementation NSObject (BSHUD)

- (void)showHud{
    [self showHudWithDuration:0];
}

- (void)showHudWithDuration:(NSTimeInterval)duration{
    [self showHudWithDuration:duration timeoutTip:nil];
}

- (void)showHudWithDuration:(NSTimeInterval)duration timeoutTip:(nullable NSString *)timeoutTip{
    [self showHudWithDuration:duration hint:nil timeoutTip:timeoutTip];
}

- (void)showHudWithDuration:(NSTimeInterval)duration hint:(nullable NSString *)hint timeoutTip:(nullable NSString *)timeoutTip{
    [self showHudInView:nil hint:hint duration:duration timeoutTip:timeoutTip];
}

- (void)showHudInView:(nullable UIView *)view{
    [self showHudInView:view duration:0];
}

- (void)showHudInView:(nullable UIView *)view duration:(NSTimeInterval)duration{
    [self showHudInView:view hint:nil duration:duration];
}

- (void)showHudInView:(nullable UIView *)view hint:(nullable NSString *)hint{
    [self showHudInView:view hint:hint duration:0];
}

- (void)showHudInView:(nullable UIView *)view hint:(nullable NSString *)hint duration:(NSTimeInterval)duration{
    [self showHudInView:view hint:hint duration:duration timeoutTip:nil];
}

- (void)showHudInView:(nullable UIView *)view hint:(nullable NSString *)hint duration:(NSTimeInterval)duration timeoutTip:(nullable NSString *)timeoutTip{
    MBProgressHUD *hud = [self hudInView:view];
    if (!hud) {
        return;
    }
    if (hint && hint.length > 0) {
        hud.label.text = hint;
        hud.bezelView.color = [UIColor colorWithWhite:0.8f alpha:0.6f];
    }
    [hud showAnimated:YES];
    if(duration <= 0){
        return;
    }
    if (!timeoutTip || timeoutTip.length == 0) {
        [hud hideAnimated:YES afterDelay:duration];
        return;
    }
    [self performSelector:@selector(showHint:) withObject:timeoutTip afterDelay:duration];
}

- (void)showHint:(NSString *)hint{
    [self showHint:hint yOffset:0];
}

- (void)showHintInWindow:(NSString *)hint {
    [self showHint:hint view:UIApplication.sharedApplication.windows.firstObject];
}

- (void)showHint:(nullable NSString *)hint view:(nullable UIView*)view {
    [self showHint:hint view:view yOffset:0];
}

- (void)showFullScreenLoadingViewWithHint:(NSString *)hint{
    [self showFullScreenLoadingViewWithHint:hint afterDelay:60];
}

- (void)showFullScreenLoadingViewWithHint:(NSString *)hint afterDelay:(NSTimeInterval)delay{
    //显示提示信息
    MBProgressHUD *hud = [self hudInWindow];
    if (!hud) {
        return;
    }
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.51];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor clearColor];

    UIImage *image = [[UIImage imageNamed:@"loading_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [imgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    hud.customView = imgView;

    hud.label.text = hint;
    hud.label.font = [UIFont bs_PingFangBoldFontWithFontSize:16.0f];
    hud.label.textColor = [UIColor whiteColor];
    hud.label.numberOfLines = 0;
    hud.margin = 10.f;
    [hud showAnimated:YES];
    //最大显示时长
    [hud hideAnimated:YES afterDelay:delay];
}

- (void)showHint:(nullable NSString *)hint yOffset:(float)yOffset{
    [self cancelShowHintPerformRequest];
    if ([BSStringUtil isBlankWithString:hint]) {
        [self hideHud];
        return;
    }
    //显示提示信息
    MBProgressHUD *hud = [self hudInView:nil];
    if (!hud) {
        return;
    }
    hud.minShowTime = 1.5;
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.label.numberOfLines = 0 ;
    hud.inputView.layer.cornerRadius = 10.0f;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.label.font = [UIFont bs_lightFontWithFontSize:14];
    hud.label.textColor = [UIColor whiteColor];
    hud.margin = 10;
    hud.minSize = CGSizeMake(120, 44);
    hud.bezelView.color = [UIColor bs_colorFromARGB:@"#111113"];
    if (yOffset != 0) {
        hud.offset = CGPointMake(0,yOffset);
    }else{
        //设置居中显示
        hud.offset  = CGPointMake(0,0);
    }
    CGFloat delay = [self durationWithHint:hint];
    [hud hideAnimated:YES afterDelay:delay];
}

- (void)showHint:(nullable NSString *)hint view:(nullable UIView*)view yOffset:(float)yOffset
{
    [self cancelShowHintPerformRequest];
    if ([BSStringUtil isBlankWithString:hint]) {
        [self hideHud];
        return;
    }
    //显示提示信息
    MBProgressHUD *hud = [self hudInView:view];
    if (!hud) {
        return;
    }
    hud.minShowTime = 1.5;
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.label.numberOfLines = 0 ;
    hud.inputView.layer.cornerRadius = 2.0f;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.label.textColor = [UIColor whiteColor];
    hud.margin = 5.f;
    hud.minSize = CGSizeMake(120, 44);
    if (yOffset != 0) {
        hud.bezelView.color = [UIColor bs_colorFromARGB:@"#2D2D2D"];
        hud.offset = CGPointMake(0,yOffset);
    }else{
        hud.bezelView.color = [UIColor bs_colorFromARGB:@"#2D2D2D"];
        hud.offset  = CGPointMake(0,0);
    }
    [hud hideAnimated:YES afterDelay:3];
}

- (void)showHint:(nullable NSString *)hint backAlpha:(float)alpha {
    [self cancelShowHintPerformRequest];
    if ([BSStringUtil isBlankWithString:hint]) {
        return;
    }
    //显示提示信息
    MBProgressHUD *hud = [self hudInView:nil];
    if (!hud) {
        return;
    }
    hud.minSize = CGSizeMake(120, 44);
    hud.minShowTime = 1.5;
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 5.f;
    hud.inputView.layer.cornerRadius = 2.0f;
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.label.textColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor bs_colorFromARGB:@"#2D2D2D"];
    [hud hideAnimated:YES afterDelay:3];
}

- (void)showActiveHUD
{
    [self showActiveHUDInView:nil];
}

- (void)showActiveHUDInView:(nullable UIView *)view
{
    if (!view) {
        view = [self topView];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    [hud showAnimated:YES];
    [self setHUD:hud];
}

- (void)showHudInWindow{
    [self showHudInView:[UIApplication sharedApplication].windows.firstObject];
}

- (void)hideHud{
    [self cancelShowHintPerformRequest];
    [[self HUD] hideAnimated:YES];
}

#pragma mark- Private methods

- (MBProgressHUD *)hudInView:(nullable UIView *)view{
    UIView *superView = view ? : [self topView];
    if(!superView){
        return nil;
    }
    MBProgressHUD *hud = [superView viewWithTag:kDefaultHUDViewTag];
    if (!hud || hud.superview != superView) {
        hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        hud.tag = kDefaultHUDViewTag;
        hud.backgroundColor = [UIColor clearColor];
        hud.removeFromSuperViewOnHide = YES;
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.f];
        hud.minSize = CGSizeMake(120, 44);
    }else{
        [hud showAnimated:YES];
    }
    [self setHUD:hud];
    return hud;
}

- (MBProgressHUD *)hudInWindow{
    UIView *superView = [self topWindow];
    if(!superView){
        return nil;
    }
    MBProgressHUD *hud = [superView viewWithTag:kDefaultHUDViewTag];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        hud.tag = kDefaultHUDViewTag;
        hud.backgroundColor = [UIColor clearColor];
        hud.removeFromSuperViewOnHide = YES;
    }else{
        [hud showAnimated:YES];
    }
    [self setHUD:hud];
    return hud;
}

- (UIWindow *)topWindow{
    return [[UIApplication sharedApplication].windows firstObject];
}

- (UIView *)topView{
    return [[self topWindow] topViewController].view;
}

- (void)cancelShowHintPerformRequest{
    @try {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    } @catch (NSException *exception) {
        NSLog(@"exception: %@",exception.reason);
    }
}

- (NSTimeInterval)durationWithHint:(NSString *)hint{
    CGFloat delay = 1;
    if (hint && hint.length > 0) {
        CGFloat maxWidth = kScreenWidth - self.HUD.margin * 2;
        CGFloat width = [hint boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:self.HUD.label.font} context:nil].size.width;
        delay = (width < (maxWidth - 10 * 2)) ? delay : 3;
    }
    return delay;
}

#pragma mark- Setters && Getters

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
