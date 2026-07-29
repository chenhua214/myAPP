

#import <UIKit/UIKit.h>
#import "UIBezierPath+BSAdd.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum :NSInteger{
    ZLJShadowPathLeft,
    ZLJShadowPathRight,
    ZLJShadowPathTop,
    ZLJShadowPathBottom,
    ZLJShadowPathNoTop,
    ZLJShadowPathNoRight,
    ZLJShadowPathAllSide
} ZLJShadowPathSide;

@interface UIView (BSCorner)

/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *
 */
- (void)bs_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;


/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param boardColor 边框颜色
 *  @param boardWith 边框宽度
 *
 *  @return CAShapeLayer 对象
 */
- (CAShapeLayer *)bs_addRoundedCorners:(UIRectCorner)corners
                          withRadii:(CGSize)radii
                         boardColor:(UIColor *)boardColor
                          boardWith:(CGFloat)boardWith;

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 *
 */
- (void)bs_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

/**
 *  设置部分圆角
 *
 *  @param corner 需要设置为圆角的角 //1、上左右；2下左右；3all；4右上下
 *  @param radius   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param needChange    大小变化时是否需要刷新
 *
 */
- (void)bs_addRoundedCorner:(NSInteger)corner
                      radius:(CGFloat)radius
                  needChange:(BOOL)needChange;

/**
 *  设置圆角
 *
 *  @param cornerRadius 需要设置为圆角的角 //1、上左右；2下左右；3all；4右上下
 *
 */
- (void)bs_addCornerRadius:(ZLJRadius)cornerRadius;

- (void)bs_addBackgroundColor:(UIColor *)backgroundColor
                 cornerRadius:(CGFloat)cornerRadius
                  shadowColor:(UIColor *)color
                       offset:(CGSize)offset
                       radius:(CGFloat)radius
                      opacity:(CGFloat)opacity;

- (void)bs_addShadow:(BOOL)add
               color:(nullable UIColor *)color
              offset:(CGSize)offset
              radius:(CGFloat)radius
             opacity:(CGFloat)opacity;

/**
 *  重新绘制
 *
 */
- (void)bs_cornerRadiusNeedLayout;

@property (nonatomic, assign) CGFloat   bs_CornerRadius;//圆角大小
@property (nonatomic, assign) NSInteger bs_CornersType;//类型
@property (nonatomic, assign) BOOL      bs_CornerIsNeedChange;//是否随大小变化需要刷新
@property (nonatomic, assign) BOOL      bs_CornerIsDrawRect;//标记是否已经绘制
@property (nonatomic, assign) CGSize    bs_CornerSize;//大小

@end

NS_ASSUME_NONNULL_END
