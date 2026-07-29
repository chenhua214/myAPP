//
//  UIView+Status.h
//  BatteryStation
//
//  Created by immotor on 2019/4/22.
//  Copyright © 2019 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Status)
- (void)status_progress;

- (void)status_failed:(NSString *)reason target:(id)target selector:(SEL)selector;

- (void)status_empty:(NSString *)text imageName:(nullable NSString *)imageName;

- (void)status_success;

@end

NS_ASSUME_NONNULL_END
