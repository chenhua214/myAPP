//
//  UITabBar+BSAddition.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/20.
//

#import "UITabBar+BSAddition.h"

@implementation UITabBar (BSAddition)

- (void)tabBarBackgroundColor:(nullable UIColor *)backgroundColor customSeparatorColor:(nullable UIColor *)separatorColor{
    [self tabBarBackgroundColor:backgroundColor customSeparatorColor:separatorColor height:0.5];
}

- (void)tabBarBackgroundColor:(nullable UIColor *)backgroundColor customSeparatorColor:(nullable UIColor *)separatorColor height:(CGFloat)height{
    //自定义分割线
    UIView *customSepartorView = nil;
    if (separatorColor) {
        customSepartorView = [UIView new];
        customSepartorView.backgroundColor = separatorColor;
        [customSepartorView setFrame:CGRectMake(0, -height, CGRectGetWidth(self.frame), height)];
    }
    BOOL shouldBreak = NO;
    for(UIView *view in self.subviews) {
        shouldBreak = [self tabBarBackgroundView:view resetBackgroundColor:backgroundColor customSeparatorView:customSepartorView];
        if (shouldBreak) {
            break;
        }
    }
}

- (BOOL)tabBarBackgroundView:(UIView *)view resetBackgroundColor:(nullable UIColor *)backgroundColor customSeparatorView:(nullable UIView *)separatorView{
//    NSLog(@"class : %@",NSStringFromClass([view class]));
    if(![NSStringFromClass([view class]) isEqualToString:@"_UIBarBackground"]) {
        return NO;
    }
    UIView *backgroundView = view;
    //设置背景色
    if (backgroundColor) {
        backgroundView.backgroundColor = backgroundColor;
    }
    if (separatorView) {
        [backgroundView addSubview:separatorView];
    }
    // 隐藏头部的线
    for(UIView *view in backgroundView.subviews) {
        if([view isKindOfClass:[UIImageView class]]) {
            view.hidden = YES;
        }else if([NSStringFromClass([view class]) isEqualToString:@"_UIBarBackgroundShadowView"]) {
            view.hidden = YES;
        }
    }
    return YES;
}

@end
