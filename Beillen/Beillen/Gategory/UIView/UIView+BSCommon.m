//
//  UIView+Common.m
//  BaseusAPP
//
//  Created by  wang on 2021/1/20.
//

#import "UIView+BSCommon.h"

@implementation UIView (BSCommon)

+ (UILabel *)bs_labelWithFont:(UIFont * __nullable)font
              textAlignment :(NSTextAlignment)textAlignment
                   textColor:(UIColor * __nullable)textColor{
    return [self bs_labelWithFont:font textAlignment:textAlignment textColor:textColor bgColor:nil];
}

+(UILabel *)bs_labelWithFont:(UIFont * __nullable)font
              textAlignment :(NSTextAlignment)textAlignment
                   textColor:(UIColor * __nullable)textColor
                     bgColor:(UIColor * __nullable)bgColor {
    UILabel *label = [[UILabel alloc]init];
    if (font) {
        label.font = font;
    }
    label.textAlignment = textAlignment;
    if (textColor) {
        label.textColor = textColor;
    }
    if (bgColor) {
        label.backgroundColor = bgColor;
    }
    return label;
}

+(UITextField *)bs_textFieldWithFont:(UIFont * __nullable)font
                      textAlignment :(NSTextAlignment)textAlignment
                           textColor:(UIColor * __nullable)textColor
                         placeholder:(NSString * __nullable)placeholder
                    placeholderColor:(UIColor * __nullable)placeholderColor
                     placeholderFont:(UIFont * __nullable)placeholderFont {
    UITextField *field = [[UITextField alloc]init];
    if (font) {
        field.font = font;
    }
    field.textAlignment = textAlignment;
    if (textColor) {
        field.textColor = textColor;
    }
    NSMutableAttributedString *attPlaceholder = nil;
    if (placeholder) {
        attPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder];
        if (placeholderColor) {
            [attPlaceholder addAttributes:@{NSForegroundColorAttributeName:placeholderColor} range:NSMakeRange(0,placeholder.length)];
        }
        if (placeholderFont) {
            [attPlaceholder addAttributes:@{NSFontAttributeName:placeholderFont} range:NSMakeRange(0,placeholder.length)];
        }
        field.attributedPlaceholder = attPlaceholder;
    }
    return field;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled alphaForAll:(float)alpha{
    if(self.userInteractionEnabled == userInteractionEnabled){
        return;
    }
    self.userInteractionEnabled = userInteractionEnabled;
    self.alpha = userInteractionEnabled ? 1 : alpha;
    if (!userInteractionEnabled) {
        for (UIView *subview in self.subviews) {
            subview.alpha = alpha;
        }
        return;
    }
    for (UIView *subview in self.subviews) {
        subview.alpha = 1;
    }
}

- (void)addGradientLayer:(BOOL)add {
    NSArray<UIColor *> *colors = @[[UIColor bs_colorFromARGB:@"#353741"], [UIColor bs_colorFromARGB:@"#181A20"]];
    [self addGradientLayer:add colors:colors];
}

- (void)addGradientLayer:(BOOL)add colors:(NSArray<UIColor *> *)colors{
    [self addGradientLayer:add startPoint:CGPointMake(0.5, 0.5) endPoint:CGPointMake(1, 1) colors:colors locations:@[@(0), @(1.0f)]];
}

- (void)addGradientLayer:(BOOL)add startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations{
    NSString *layerName = @"BS.View.Gradient.Layer";
    CAGradientLayer *gl = (CAGradientLayer *)[self layerWithName:layerName class:CAGradientLayer.class];
    if (gl != nil) { [gl removeFromSuperlayer]; }
    if (!add) { return; }
    if (CGRectIsEmpty(self.bounds) && self.superview) {
        [self.superview layoutIfNeeded];
    }
    NSMutableArray *colorRefs = @[].mutableCopy;
    for (UIColor * color in colors) {
        [colorRefs addObject:(__bridge id)color.CGColor];
    }
    gl = [CAGradientLayer layer];
    gl.frame = self.bounds;
    gl.startPoint = startPoint;
    gl.endPoint = endPoint;
    gl.colors = colorRefs;
    gl.locations = @[@(0), @(1.0f)];
    gl.name = layerName;
    [self.layer insertSublayer:gl atIndex:0];
}

- (nullable CALayer *)layerWithName:(NSString *)layerName class:(Class)class{
    CALayer *gl = nil;
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:class] && [layer.name isEqualToString:layerName]) {
            gl = layer;
        }
    }
    return gl;
}

@end
