


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (BSFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
/// 实际上设置x
@property (nonatomic, assign) CGFloat right;
// add liangrc
/// 实际上设置宽
@property (nonatomic, assign) CGFloat right_width;
/// 实际上设置高
@property (nonatomic, assign) CGFloat bottom_height;

@end

NS_ASSUME_NONNULL_END
