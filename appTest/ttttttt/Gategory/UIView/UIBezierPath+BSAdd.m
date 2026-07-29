

#import "UIBezierPath+BSAdd.h"

@implementation UIBezierPath (BSAdd)

/**
 * 切割圆角
 *
 * @param rect view的frame
 * @param radius 圆角 上左，上右，下左，下右
 * @return bezierPath
 */
+ (UIBezierPath *)bs_pathWithRect:(CGRect)rect
                            radius:(ZLJRadius)radius {
    return [self bs_pathWithRect:rect radius:radius addClip:NO];
}

/**
 * 切割圆角
 *
 * @param rect view的frame
 * @param radius 圆角 上左，上右，下左，下右
 * @param addClip 图形绘制超出当前路径范围则不可见
 * @return bezierPath
 */
+ (UIBezierPath *)bs_pathWithRect:(CGRect)rect
                            radius:(ZLJRadius)radius
                           addClip:(BOOL)addClip {
    UIBezierPath *path = [UIBezierPath bezierPath];
     CGFloat minX = 0, minY = 0, maxX = rect.size.width, maxY = rect.size.height;
    // 上边
    [path moveToPoint:CGPointMake(minX+radius.topLeft, minY)];
    [path addLineToPoint:CGPointMake(maxX-radius.topRight, minY)];
    // 右上
    [path addArcWithCenter:CGPointMake(maxX-radius.topRight, minY+radius.topRight) radius:radius.topRight startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(maxX, maxY-radius.bottomRight)];
    // 右下
    [path addArcWithCenter:CGPointMake(maxX-radius.bottomRight, maxY-radius.bottomRight) radius:radius.bottomRight startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(minX+radius.bottomLeft, maxY)];
    // 左下
    [path addArcWithCenter:CGPointMake(minX+radius.bottomLeft, maxY-radius.bottomLeft) radius:radius.bottomLeft startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(minX, minY+radius.topLeft)];
    [path addArcWithCenter:CGPointMake(minX+radius.topLeft, minY+radius.topLeft) radius:radius.topLeft startAngle:M_PI endAngle:M_PI_2*3 clockwise:YES];
    if (addClip) {
        [path addClip];
    }
    return path;
}


@end
