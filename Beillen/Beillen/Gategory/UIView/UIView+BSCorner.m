

#import "UIView+BSCorner.h"
#import <objc/runtime.h>

static NSString *kZljCornerKey = @"bs_cornerKey";
static NSString *kZljIsDrawRectKey = @"bs_IsDrawRectKey";
static NSString *kZljRadiusKey = @"bs_RadiusKey";
static NSString *kZljIsNeedchangeKey = @"bs_IsNeedChangeKey";
static NSString *kZljLastCGSizeKey = @"bs_LastCGSizeKey";
@implementation UIView (BSCorner)

/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)bs_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    [self bs_addRoundedCorners:corners withRadii:radii viewRect:self.bounds];
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)bs_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
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
                           boardWith:(CGFloat)boardWith {

    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    shape.strokeColor = boardColor.CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.lineWidth = boardWith;
    shape.lineCap = kCALineCapSquare;
    [shape setPath:rounded.CGPath];
    [self.layer addSublayer:shape];
    return shape;
}

- (void)bs_addCornerRadius:(ZLJRadius)cornerRadius {
    UIBezierPath *path = [UIBezierPath bs_pathWithRect:self.bounds radius:cornerRadius];
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = path.CGPath;
    self.layer.mask = mask;
}

- (void)bs_addBackgroundColor:(UIColor *)backgroundColor
                 cornerRadius:(CGFloat)cornerRadius
                  shadowColor:(UIColor *)color
                       offset:(CGSize)offset
                       radius:(CGFloat)radius
                      opacity:(CGFloat)opacity{
    self.backgroundColor = backgroundColor ? : [UIColor whiteColor];
    self.layer.cornerRadius = cornerRadius;
    [self bs_addShadow:YES color:color offset:offset radius:radius opacity:opacity];
}

- (void)bs_addShadow:(BOOL)add
               color:(nullable UIColor *)color
              offset:(CGSize)offset
              radius:(CGFloat)radius
             opacity:(CGFloat)opacity {
    //先清除之前的设置
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 0;
    self.layer.shadowOpacity = 0;
    
    if (!add) { return; }
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
}

/** ============================== 分割线 ================================= */

- (void)setBs_CornerRadius:(CGFloat)bs_CornerRadius{
    objc_setAssociatedObject(self, &kZljRadiusKey, @(bs_CornerRadius), OBJC_ASSOCIATION_COPY);
}

- (CGFloat)bs_CornerRadius {
    NSNumber *number = objc_getAssociatedObject(self, &kZljRadiusKey);
    return [number floatValue];
}

- (void)setBs_CornerIsDrawRect:(BOOL)bs_CornerIsDrawRect{
    objc_setAssociatedObject(self, &kZljIsDrawRectKey, @(bs_CornerIsDrawRect), OBJC_ASSOCIATION_COPY);
}

- (BOOL)bs_CornerIsDrawRect {
    NSNumber *number = objc_getAssociatedObject(self, &kZljIsDrawRectKey);
    return [number boolValue];
}

- (void)setBs_CornersType:(NSInteger)bs_CornersType{
    objc_setAssociatedObject(self, &kZljCornerKey, @(bs_CornersType), OBJC_ASSOCIATION_COPY);
}

- (NSInteger)bs_CornersType {
    NSNumber *number = objc_getAssociatedObject(self, &kZljCornerKey);
    return [number integerValue];
}

- (void)setBs_CornerIsNeedChange:(BOOL)bs_CornerIsNeedChange{
    objc_setAssociatedObject(self, &kZljIsNeedchangeKey, @(bs_CornerIsNeedChange), OBJC_ASSOCIATION_COPY);
}

- (BOOL)bs_CornerIsNeedChange{
    NSNumber *number = objc_getAssociatedObject(self, &kZljCornerKey);
    return [number boolValue];
}

- (void)setBs_CornerSize:(CGSize)bs_CornerSize{
    objc_setAssociatedObject(self, &kZljLastCGSizeKey, [NSValue valueWithCGSize:bs_CornerSize], OBJC_ASSOCIATION_COPY);
}

- (CGSize)bs_CornerSize {
    NSValue *value = objc_getAssociatedObject(self, &kZljLastCGSizeKey);
    return [value CGSizeValue];
}

- (void)bs_addRoundedCorner:(NSInteger)corner
                      radius:(CGFloat)radius
                  needChange:(BOOL)needChange {
    self.bs_CornersType = corner;
    self.bs_CornerRadius = radius;
    self.bs_CornerIsNeedChange = needChange;
}

- (void)bs_cornerRadiusNeedLayout {
    if (self.bs_CornersType == 1) {
        [self bs_addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(self.bs_CornerRadius, self.bs_CornerRadius)];
    }else if (self.bs_CornersType == 2){
        [self bs_addRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withRadii:CGSizeMake(self.bs_CornerRadius, self.bs_CornerRadius)];
    }else if (self.bs_CornersType == 3){
        [self bs_addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(self.bs_CornerRadius, self.bs_CornerRadius)];
    }else if (self.bs_CornersType == 4){
        [self bs_addRoundedCorners:UIRectCornerTopRight|UIRectCornerBottomRight withRadii:CGSizeMake(self.bs_CornerRadius, self.bs_CornerRadius)];
    }else{
        [self bs_addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(self.bs_CornerRadius, self.bs_CornerRadius)];
    }
}

- (void)layoutSubviews {
    if ((self.bs_CornerRadius > 0 && !self.bs_CornerIsDrawRect) || (self.bs_CornerIsNeedChange && self.bs_CornerSize.width != self.width && self.bs_CornerSize.height != self.height && self.bs_CornerSize.width > 0 && self.bs_CornerSize.height > 0 && self.bs_CornerRadius > 0)) {
        if (self.bounds.size.height == 0) {
            return;
        }
        self.bs_CornerSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        self.bs_CornerIsDrawRect = YES;
        if (self.bs_CornersType == 1) {
            [self bs_addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(self.bs_CornerRadius, self.bs_CornerRadius)];
        }else if (self.bs_CornersType == 2){
            [self bs_addRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withRadii:CGSizeMake(self.bs_CornerRadius, self.bs_CornerRadius)];
        }else if (self.bs_CornersType == 3){
            [self bs_addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(self.bs_CornerRadius, self.bs_CornerRadius)];
        }else if (self.bs_CornersType == 4){
            [self bs_addRoundedCorners:UIRectCornerTopRight|UIRectCornerBottomRight withRadii:CGSizeMake(self.bs_CornerRadius, self.bs_CornerRadius)];
        }else{
            [self bs_addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(self.bs_CornerRadius, self.bs_CornerRadius)];
        }
    }
}

@end
