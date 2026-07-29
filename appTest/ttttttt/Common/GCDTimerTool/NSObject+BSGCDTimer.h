//
//  NSObject+BSGCDTimer.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BSGCDTimer)

/// 创建一个定时器
- (void)gcdTimerWithName:(NSString *)name timeInterval:(double)interval action:(dispatch_block_t)action;

/// 创建一个定时器
/// ⚠️ 当 repeats = YES 时需要自己主动 cancel
- (void)gcdTimerWithName:(NSString *)name timeInterval:(double)interval repeats:(BOOL)repeats action:(dispatch_block_t)action;

/// 取消一个定时器
- (void)gcdTimerCancelWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
