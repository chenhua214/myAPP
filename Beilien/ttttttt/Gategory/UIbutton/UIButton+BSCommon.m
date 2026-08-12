

#import "UIButton+BSCommon.h"
#import <objc/runtime.h>

@implementation UIButton (BSCommon)

// 因category不能添加属性，只能通过关联对象的方式。
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

- (NSTimeInterval)cs_acceptEventInterval {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setCs_acceptEventInterval:(NSTimeInterval)cs_acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(cs_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

- (NSTimeInterval)cs_clickEventTime {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setCs_clickEventTime:(NSTimeInterval)cs_clickEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(cs_clickEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 在load时执行hook
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //分别获取
        SEL beforeSelector = @selector(sendAction:to:forEvent:);
        SEL afterSelector = @selector(cs_sendAction:to:forEvent:);
        
        Method beforeMethod = class_getInstanceMethod(class, beforeSelector);
        Method afterMethod = class_getInstanceMethod(class, afterSelector);
        //先尝试给原来的方法添加实现，如果原来的方法不存在就可以添加成功。返回为YES，否则
        //返回为NO。
        //UIButton 真的没有sendAction方法的实现，这是继承了UIControl的而已，UIControl才真正的实现了。
        BOOL didAddMethod =
        class_addMethod(class,
                        beforeSelector,
                        method_getImplementation(afterMethod),
                        method_getTypeEncoding(afterMethod));
        NSLog(@"%d",didAddMethod);
        if (didAddMethod) {
            // 如果之前不存在，但是添加成功了，此时添加成功的是cs_sendAction方法的实现
            // 这里只需要方法替换
            class_replaceMethod(class,
                                afterSelector,
                                method_getImplementation(beforeMethod),
                                method_getTypeEncoding(beforeMethod));
        } else {
            //本来如果存在就进行交换
            method_exchangeImplementations(afterMethod, beforeMethod);
        }
    });
}

- (void)cs_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSDate date].timeIntervalSince1970 - self.cs_clickEventTime < self.cs_acceptEventInterval) {
        return;
    }
    if (self.cs_acceptEventInterval > 0) {
        self.cs_clickEventTime = [NSDate date].timeIntervalSince1970;
    }
    [self cs_sendAction:action to:target forEvent:event];
}

+ (UIButton *)bs_buttonWithTitleType:(UIButtonType)btnType frame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor font:(CGFloat)font {
    UIButton *btn = [UIButton buttonWithType:btnType];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    return btn;
}


+ (UIButton *)bs_buttonWithImageType:(UIButtonType)btnType frame:(CGRect)frame image:(UIImage *)image {
    UIButton *btn = [UIButton buttonWithType:btnType];
    btn.frame = frame;
    [btn setImage:image forState:UIControlStateNormal];
    return btn;
}

+ (UIButton *)bs_defaultButtonWithTitle:(NSString *)title

                                font:(CGFloat)font
{
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    if (font==0 ) font = 16 ;
    [button setTitleColor: [UIColor bs_colorFromARGB:@"#FFFFFF"]  forState:UIControlStateNormal];
//    [button setTitleColor: [UIColor bs_colorFromARGB:@"#000000"]  forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont bs_regularFontWithFontSize:font];
//    [button setBackgroundImage:[UIImage imageNamed:@"btnBgNomal"] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"huiBtnbg"] forState:UIControlStateDisabled];
    [button setBackgroundImage:[UIImage bs_imageWithColor:[UIColor bs_BtnBackColor] cornerRadius:5] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage bs_imageWithColor:[UIColor bs_BtnBackDisabledColor] cornerRadius:5] forState:UIControlStateDisabled];
    button.frame = CGRectMake(kSpaceWidth24, 0, kSCREEN_WIDTH-kSpaceWidth24*2, kSpaceHeight51) ;
    return button;
}


+ (UIButton *)bs_BSyellowColorButtonWithTitle:(NSString *)title
                                font:(CGFloat)font
{
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    if (font==0 ) font = 14 ;
    [button setTitleColor: [UIColor bs_colorFromARGB:@"#111113"]  forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont bs_regularFontWithFontSize:font];
    [button setBackgroundImage:[UIImage bs_imageWithColor:[UIColor bs_colorFromARGB:@"#FFE800"] cornerRadius:5] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage bs_imageWithColor:[UIColor bs_colorFromARGB:@"#FFE800" alpha:0.4] cornerRadius:5] forState:UIControlStateDisabled];
    button.frame = CGRectMake(kSpaceWidth24, 0, kSCREEN_WIDTH-kSpaceWidth24*2, kSpaceHeight51) ;
    return button;
}

+ (UIButton *)bs_defaultBtnBackWithTitle:(NSString *)title
{
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor: [UIColor bs_colorFromARGB:@"#FFFFFF"]  forState:UIControlStateNormal];
//    [button setTitleColor: [UIColor bs_colorFromARGB:@"#000000"]  forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont bs_regularFontWithFontSize:16];
    [button setBackgroundImage:[UIImage bs_imageWithColor:[UIColor bs_BtnBackColor] cornerRadius:5] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage bs_imageWithColor:[UIColor bs_BtnBackDisabledColor] cornerRadius:5] forState:UIControlStateDisabled];
    return button;
}

+ (UIButton *)bs_defaultNewBtnWithTitle:(NSString *)title
{
    UIButton*_doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.backgroundColor = bsColorString(@"#E8E8E8");
    _doneBtn.titleLabel.font = bsFontRegular(14);
    _doneBtn.layer.cornerRadius = 6;
    
    [_doneBtn setTitle:title forState:UIControlStateNormal];
    [_doneBtn setTitleColor:bsColorString(@"#999999") forState:UIControlStateNormal];
    _doneBtn.userInteractionEnabled = NO;
    return _doneBtn;
}

+ (void)changeBtnwithButton:(UIButton *)button enabled:(BOOL )editable
{
    if (button.userInteractionEnabled == editable) return;
    button.userInteractionEnabled = editable;
    button.backgroundColor = bsColorString(editable ? @"#FFE800" : @"#E8E8E8");
    [button setTitleColor:bsColorString(editable ? @"#111113" : @"#999999") forState:UIControlStateNormal];
}

+ (UIButton *)bs_defaultBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"nav_back_black"];
    CGSize btnSize = CGSizeMake(40, 40);
    CGSize size = image.size;
    CGFloat top = (btnSize.width - size.height)/2;
    CGFloat left = 1;
    CGFloat right = btnSize.width - size.width - left;
    [backBtn setImage:image forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0,0,btnSize.width,btnSize.height);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(top,left,top,right)];
    backBtn.bs_touchInset = UIEdgeInsetsMake(-10,-10,-10,-10);
    return backBtn;
}

+ (UIButton *)bs_buttonWithComstomFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor font:(CGFloat)font {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    return btn;
}

+ (UIButton *)bs_buttonWithText:(NSString *)text titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor
                   cornerRadius:(CGFloat)cornerRadius
{
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.backgroundColor = backgroundColor;
    btn.layer.cornerRadius = cornerRadius;
    btn.layer.masksToBounds = YES;
    return btn;
}

- (void)bs_setIconInLeftWithSpacing:(CGFloat)spacing {
    self.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = spacing/2,
        .bottom = 0,
        .right  = -spacing/2,
    };
    self.imageEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = -spacing/2,
        .bottom = 0,
        .right  = spacing/2,
    };
    
}


- (void)bs_setIconInRightWithSpacing:(CGFloat)spacing {
    CGFloat img_W = self.imageView.frame.size.width;
    CGFloat tit_W = self.titleLabel.frame.size.width;
    self.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = - (img_W + spacing / 2),
        .bottom = 0,
        .right  =   (img_W + spacing / 2),
    };
    self.imageEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   =   (tit_W + spacing / 2),
        .bottom = 0,
        .right  = - (tit_W + spacing / 2),
    };
}


- (void)bs_setIconInTopWithSpacing:(CGFloat)spacing {
    CGFloat img_W = self.imageView.frame.size.width;
    CGFloat img_H = self.imageView.frame.size.height;
    CGFloat tit_W = self.titleLabel.frame.size.width;
    CGFloat tit_H = self.titleLabel.frame.size.height;
    
    self.titleEdgeInsets = (UIEdgeInsets){
        .top    =   (tit_H / 2 + spacing / 2),
        .left   = - (img_W / 2),
        .bottom = - (tit_H / 2 + spacing / 2),
        .right  =   (img_W / 2),
    };
    
    self.imageEdgeInsets = (UIEdgeInsets){
        .top    = - (img_H / 2 + spacing / 2),
        .left   =   (tit_W / 2),
        .bottom =   (img_H / 2 + spacing / 2),
        .right  = - (tit_W / 2),
    };
}

- (void)bs_setIconInBottomWithSpacing:(CGFloat)spacing {
    CGFloat img_W = self.imageView.frame.size.width;
    CGFloat img_H = self.imageView.frame.size.height;
    CGFloat tit_W = self.titleLabel.frame.size.width;
    CGFloat tit_H = self.titleLabel.frame.size.height;
    
    self.titleEdgeInsets = (UIEdgeInsets){
        .top    = - (tit_H / 2 + spacing / 2),
        .left   = - (img_W / 2),
        .bottom =   (tit_H / 2 + spacing / 2),
        .right  =   (img_W / 2),
    };
    
    self.imageEdgeInsets = (UIEdgeInsets){
        .top    =   (img_H / 2 + spacing / 2),
        .left   =   (tit_W / 2),
        .bottom = - (img_H / 2 + spacing / 2),
        .right  = - (tit_W / 2),
    };
}

- (void)configUIWithNormalBGColor:(UIColor *)normalBGColor
                  disabledBGColor:(UIColor *)disabledBGColor
                 normalTitleColor:(UIColor *)normalTitleColor
               disabledTitleColor:(UIColor *)disabledTitleColor
                      borderColor:(UIColor *)borderColor
                      borderWidth:(CGFloat)borderWidth
                     cornerRadius:(CGFloat)cornerRadius
                    masksToBounds:(BOOL)masksToBounds
                          enabled:(BOOL)enabled
{
    [self configUIWithFont:[UIFont bs_mediumFontWithFontSize:20.0]
             normalBGColor:normalBGColor
           disabledBGColor:disabledBGColor
          normalTitleColor:normalTitleColor
        disabledTitleColor:disabledTitleColor
               borderColor:borderColor
               borderWidth:borderWidth
              cornerRadius:cornerRadius
             masksToBounds:masksToBounds
                   enabled:enabled];
}

- (void)configUIWithFont:(UIFont *)font
           normalBGColor:(UIColor *)normalBGColor
         disabledBGColor:(UIColor *)disabledBGColor
        normalTitleColor:(UIColor *)normalTitleColor
      disabledTitleColor:(UIColor *)disabledTitleColor
             borderColor:(UIColor *)borderColor
             borderWidth:(CGFloat)borderWidth
            cornerRadius:(CGFloat)cornerRadius
           masksToBounds:(BOOL)masksToBounds
                 enabled:(BOOL)enabled
{
    [self configUIWithFont:font
             normalBGColor:normalBGColor
          highlightBGColor:[UIColor clearColor]
           disabledBGColor:disabledBGColor
          normalTitleColor:normalTitleColor
        disabledTitleColor:disabledTitleColor
               borderColor:borderColor
               borderWidth:borderWidth
              cornerRadius:cornerRadius
             masksToBounds:masksToBounds
                   enabled:enabled];
}

- (void)configUIWithFont:(UIFont *)font
           normalBGColor:(UIColor *)normalBGColor
        highlightBGColor:(UIColor *)highlightBGColor
         disabledBGColor:(UIColor *)disabledBGColor
        normalTitleColor:(UIColor *)normalTitleColor
      disabledTitleColor:(UIColor *)disabledTitleColor
             borderColor:(UIColor *)borderColor
             borderWidth:(CGFloat)borderWidth
            cornerRadius:(CGFloat)cornerRadius
           masksToBounds:(BOOL)masksToBounds
                 enabled:(BOOL)enabled
{
    [self.titleLabel setFont: font];
    [self setBackgroundImage:[UIImage bs_imageWithColor:normalBGColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage bs_imageWithColor:highlightBGColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage bs_imageWithColor:disabledBGColor] forState:UIControlStateDisabled];
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [self setTitleColor:disabledTitleColor forState:UIControlStateDisabled];
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = masksToBounds;
    [self configUIWithBorderColor:borderColor borderWidth:borderWidth enabled:enabled];
}

- (void)configUIWithBorderColor:(UIColor *)borderColor
                    borderWidth:(CGFloat)borderWidth
                        enabled:(BOOL)enabled
{
    self.enabled = enabled;
    self.userInteractionEnabled = enabled;
    self.layer.borderColor = enabled ? borderColor.CGColor : [UIColor clearColor].CGColor;
    self.layer.borderWidth = enabled ? borderWidth : 0;
}

- (void)configYellowGradientColorAndEnabled:(BOOL)enabled
{
    self.enabled = enabled;
    self.userInteractionEnabled = enabled;
    [self addGradientLayer:enabled colors:@[[UIColor bs_colorFromARGB:@"#FFF000"], [UIColor bs_colorFromARGB:@"#F5DE0C"]]];
}

- (void)configBlackGradientColorAndEnabled:(BOOL)enabled
{
    self.enabled = enabled;
    self.userInteractionEnabled = enabled;
    [self addGradientLayer:enabled colors:@[[UIColor bs_colorFromARGB:@"#353741"], [UIColor bs_colorFromARGB:@"#181A20"]]];
}

- (void)configUIWithGradientColors:(NSArray<UIColor *> *)colors
                           enabled:(BOOL)enabled
{
    self.enabled = enabled;
    self.userInteractionEnabled = enabled;
    [self addGradientLayer:enabled colors:colors];
}

@end
