//
//  BSGCDTimer.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/12.
//

#import "BSGCDTimer.h"
@interface BSGCDTimer ()
@property(nonatomic,strong) NSMutableDictionary *timerContainer;
@property(nonatomic,strong) NSMutableDictionary *actionBlockCache;
@end

@implementation BSGCDTimer


+ (instancetype)shareInstance{
    static BSGCDTimer *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super allocWithZone:NULL] init];
    });
    return shared;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [BSGCDTimer shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [BSGCDTimer shareInstance];
}

- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(nullable dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                          actionOption:(ActionOption)option
                                action:(dispatch_block_t)action
{
    if (nil == timerName){
        return;
    }
    
    if (nil == queue){
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }

    dispatch_source_t timer;
    @synchronized (self.timerContainer) {
        timer = [self.timerContainer objectForKey:timerName];
        if (!timer) {
            timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_resume(timer);
            [self.timerContainer setObject:timer forKey:timerName];
        }
    }
    /* timer精度为0.1秒 */
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    __weak typeof(self) weakSelf = self;
    switch (option) {
        case AbandonPreviousAction:
        {
            /* 移除之前的action */
            [self removeActionCacheForTimer:timerName];
            dispatch_source_set_event_handler(timer, ^{
                if (action) {
                    action();
                }
                if (!repeats) {
                    [weakSelf cancelTimerWithName:timerName];
                }
            });
        }
            break;
            
        case MergePreviousAction:
        {
            /* cache本次的action */
            [self cacheAction:action forTimer:timerName];
            dispatch_source_set_event_handler(timer, ^{
                NSMutableArray *actionArray = [[weakSelf.actionBlockCache objectForKey:timerName] mutableCopy];
                [actionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    dispatch_block_t actionBlock = obj;
                    actionBlock();
                }];
                [weakSelf removeActionCacheForTimer:timerName];
                if (!repeats) {
                    [weakSelf cancelTimerWithName:timerName];
                }
            });
        }
            break;
    }
}

- (void)cancelTimerWithName:(NSString *)timerName
{
    @synchronized (self.timerContainer) {
        dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
        if (!timer) {
            return;
        }
        dispatch_source_cancel(timer);
        [self.timerContainer removeObjectForKey:timerName];
    }
    [self removeActionCacheForTimer:timerName];
}

- (BOOL)existTimer:(NSString *)timerName
{
    if ([self.timerContainer objectForKey:timerName]) {
        return YES;
    }
    return NO;
}

#pragma mark - Property

- (NSMutableDictionary *)timerContainer
{
    if (!_timerContainer) {
        _timerContainer = [[NSMutableDictionary alloc] init];
    }
    return _timerContainer;
}

- (NSMutableDictionary *)actionBlockCache
{
    if (!_actionBlockCache) {
        _actionBlockCache = [[NSMutableDictionary alloc] init];
    }
    return _actionBlockCache;
}

#pragma mark - Action Cache

- (void)cacheAction:(dispatch_block_t)action forTimer:(NSString *)name
{
    if (!action || !name.isEnable) { return; }
    @synchronized (self.actionBlockCache) {
        NSString *timerName = name.copy;
        id actionArray = [self.actionBlockCache objectForKey:timerName];
        if (actionArray && [actionArray isKindOfClass:[NSMutableArray class]]) {
            [(NSMutableArray *)actionArray addObject:action];
        }else {
            NSMutableArray *array = [NSMutableArray arrayWithObject:action];
            [self.actionBlockCache setObject:array forKey:timerName];
        }
    }
}

- (void)removeActionCacheForTimer:(NSString *)timerName{
    if (!timerName.isEnable) {
        return;
    }
    @synchronized (self.actionBlockCache) {
        if (![self.actionBlockCache objectForKey:timerName]){
            return;
        }
        [self.actionBlockCache removeObjectForKey:timerName];
    }
}
@end
