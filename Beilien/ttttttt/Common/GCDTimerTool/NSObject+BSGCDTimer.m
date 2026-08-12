//
//  NSObject+BSGCDTimer.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/12.
//

#import "NSObject+BSGCDTimer.h"
#import "BSGCDTimer.h"

@implementation NSObject (BSGCDTimer)

// 创建一个定时器
- (void)gcdTimerWithName:(NSString *)name timeInterval:(double)interval action:(dispatch_block_t)action
{
    [self gcdTimerWithName:name timeInterval:interval repeats:NO action:action];
}

// 创建一个定时器
// ⚠️ 当 repeats = YES 时需要自己主动 cancel
- (void)gcdTimerWithName:(NSString *)name timeInterval:(double)interval repeats:(BOOL)repeats action:(dispatch_block_t)action
{
    @weakify(self);
    dispatch_queue_t queue = dispatch_queue_create("BSGCDTimerTaskQueue", DISPATCH_QUEUE_CONCURRENT);
    [[BSGCDTimer shareInstance] scheduledDispatchTimerWithName:name timeInterval:interval queue:queue repeats:repeats actionOption:AbandonPreviousAction action:^{
        @strongify(self);
        if (!repeats) [self gcdTimerCancelWithName:name];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (action) action();
        });
    }];
}

// 取消一个定时器
- (void)gcdTimerCancelWithName:(NSString *)name
{
    [[BSGCDTimer shareInstance] cancelTimerWithName:name];
}

@end
