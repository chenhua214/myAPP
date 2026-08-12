//
//  BSGCDTimer.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/12.
//

#import <Foundation/Foundation.h>
#define orderPayTimeName @"orderPayTimeName"
#define storeHomeHotSearchTimeName @"storeHomeHotSearchTimeName"
typedef enum : NSUInteger {
    AbandonPreviousAction, // 废除同一个timer之前的任务
    MergePreviousAction    // 将同一个timer之前的任务合并到新的任务中
} ActionOption;

NS_ASSUME_NONNULL_BEGIN

@interface BSGCDTimer : NSObject
+ (instancetype)shareInstance;

/**
 启动一个timer，默认精度为0.1秒。
 
 @param timerName       timer的名称，作为。
 @param interval        执行的时间间隔。 unit: second
 @param queue           timer将被放入的队列，也就是最终action执行的队列。传入nil将自动放到一个子线程队列中。
 @param repeats         timer是否循环调用。
 @param option    多次schedule同一个timer时的操作选项(目前提供将之前的任务废除或合并的选项)。
 @param action          时间间隔到点时执行的block。
 */
- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(nullable dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                          actionOption:(ActionOption)option
                                action:(dispatch_block_t)action;


/**
 撤销某个timer。
 
 @param timerName timer的名称，作为
 */
- (void)cancelTimerWithName:(NSString *)timerName;

/**
 *  是否存在某个名称的timer。
 *
 *  @param timerName timer的
 *
 *  @return YES表示存在，反之。
 */
- (BOOL)existTimer:(NSString *)timerName;

@end

NS_ASSUME_NONNULL_END
