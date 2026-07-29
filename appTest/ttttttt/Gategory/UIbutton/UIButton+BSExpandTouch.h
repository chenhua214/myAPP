

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (BSExpandTouch)
// 拓宽同层级的点击范围   跨层级不响应  负数扩大正数减小
@property(assign, nonatomic) UIEdgeInsets bs_touchInset;

@end

NS_ASSUME_NONNULL_END
