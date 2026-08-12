//
//  UIBezierPath+ZLJAdd.h
//  BaseusAPP
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef struct {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} ZLJRadius;

UIKIT_STATIC_INLINE ZLJRadius ZLJRadiusMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight){
    ZLJRadius radius = {topLeft, topRight, bottomLeft, bottomRight};
    return radius;
}

@interface UIBezierPath (BSAdd)

/**
 * 切割圆角
 *
 * @param rect view的frame
 * @param radius 圆角 上左，上右，下左，下右
 *
 * @return bezierPath
 */
+ (UIBezierPath *)bs_pathWithRect:(CGRect)rect
                            radius:(ZLJRadius)radius;

/**
 * 切割圆角
 *
 * @param rect view的frame
 * @param radius 圆角 上左，上右，下左，下右
 * @param addClip 图形绘制超出当前路径范围则不可见
 *
 * @return bezierPath
 */
+ (UIBezierPath *)bs_pathWithRect:(CGRect)rect
                            radius:(ZLJRadius)radius
                           addClip:(BOOL)addClip;

@end

NS_ASSUME_NONNULL_END
