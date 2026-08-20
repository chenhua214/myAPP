//
//  NSObject+BSIpad.h
//  Beillen
//
//  Created by jy w on 2024/3/6.
//  Copyright © 2024 Beillen.All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BSRefreshIpadScreenProtocol <NSObject>

@optional
- (void)refreshIpadScreenSizeAction:(CGSize)size;

@end

@interface NSObject (BSIpad)<BSRefreshIpadScreenProtocol>

/// 获取屏幕宽度
- (CGFloat)screenWidth:(CGSize)size;

/// 获取屏幕高度
- (CGFloat)screenHeight:(CGSize)size;

/// 获取屏幕宽高
- (CGSize)screenSize:(CGSize)size;


/// 动态计算组件的宽度
/// - Parameters:
///   - width: 当前屏幕宽度
///   - max: 最大宽度
///   - margin: 组件左右边距
- (CGFloat)screenMaxWidth:(CGFloat)width max:(CGFloat)max margin:(CGFloat)margin;

/// 拉伸后当前设置填充屏幕的最大宽度
/// - Parameters:
///   - size: 如果不为空，那么以size.width与max做比较
///   - max: 如果w > h，再进行w > max ，反之直接返回w
- (CGFloat)screenFillWidth:(CGSize)size max:(CGFloat)max;

/// 添加、移除界面更改通知
- (void)addRefreshIpadScreenSizeNotification;
- (void)removeRefreshIpadScreenSizeNotification;
@end

NS_ASSUME_NONNULL_END
