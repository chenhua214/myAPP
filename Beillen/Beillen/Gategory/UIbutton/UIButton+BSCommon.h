

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (BSCommon)

@property (nonatomic, assign) NSTimeInterval cs_acceptEventInterval; // 重复点击的间隔

@property (nonatomic, assign) NSTimeInterval cs_clickEventTime;

/**
 *  自定义创建button·
 *  @param frame 大小
 *  @param btnType    按钮的类型
 *  @param title      标题
 *  @param titleColor 标题颜色
 *  @return UIBUtton 对象
 */
+ (UIButton *)bs_buttonWithTitleType:(UIButtonType)btnType
                                frame:(CGRect)frame
                                title:(NSString *)title
                           titleColor:(UIColor *)titleColor
                                 font:(CGFloat)font;


+ (UIButton *)bs_buttonWithImageType:(UIButtonType)btnType
                                frame:(CGRect)frame
                                image:(UIImage *)image;


+ (UIButton *)bs_buttonWithComstomFrame:(CGRect)frame
                                   title:(NSString *)title
                              titleColor:(UIColor *)titleColor
                                    font:(CGFloat)font;

+ (UIButton *)bs_buttonWithText:(NSString *)text titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;

- (void)bs_setIconInLeftWithSpacing:(CGFloat)spacing;

- (void)bs_setIconInRightWithSpacing:(CGFloat)spacing;

- (void)bs_setIconInTopWithSpacing:(CGFloat)spacing;

- (void)bs_setIconInBottomWithSpacing:(CGFloat)spacing;

//***
//
//  @param title      标题
//*  @param titleColor 标题颜色  为空默认黑色
//* @param  font       字号    0 默认16字号
//*  @return
+ (UIButton *)bs_defaultButtonWithTitle:(NSString *)title
                                   font:(CGFloat)font;

+ (UIButton *)bs_BSyellowColorButtonWithTitle:(NSString *)title

                                         font:(CGFloat)font ;

+ (UIButton *)bs_defaultBtnBackWithTitle:(NSString *)title;
+ (UIButton *)bs_defaultNewBtnWithTitle:(NSString *)title ;
+ (void)changeBtnwithButton:(UIButton *)button enabled:(BOOL )editable ;
+ (UIButton *)bs_defaultBackBtn;

- (void)configUIWithNormalBGColor:(UIColor *)normalBGColor
                  disabledBGColor:(UIColor *)disabledBGColor
                 normalTitleColor:(UIColor *)normalTitleColor
               disabledTitleColor:(UIColor *)disabledTitleColor
                      borderColor:(UIColor *)borderColor
                      borderWidth:(CGFloat)borderWidth
                     cornerRadius:(CGFloat)cornerRadius
                    masksToBounds:(BOOL)masksToBounds
                          enabled:(BOOL)enabled;

- (void)configUIWithFont:(UIFont *)font
           normalBGColor:(UIColor *)normalBGColor
         disabledBGColor:(UIColor *)disabledBGColor
        normalTitleColor:(UIColor *)normalTitleColor
      disabledTitleColor:(UIColor *)disabledTitleColor
             borderColor:(UIColor *)borderColor
             borderWidth:(CGFloat)borderWidth
            cornerRadius:(CGFloat)cornerRadius
           masksToBounds:(BOOL)masksToBounds
                 enabled:(BOOL)enabled;

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
                 enabled:(BOOL)enabled;

- (void)configUIWithBorderColor:(UIColor *)borderColor
                    borderWidth:(CGFloat)borderWidth
                        enabled:(BOOL)enabled;

- (void)configYellowGradientColorAndEnabled:(BOOL)enabled;

- (void)configBlackGradientColorAndEnabled:(BOOL)enabled;

- (void)configUIWithGradientColors:(NSArray<UIColor *> *)colors
                           enabled:(BOOL)enabled;
@end

NS_ASSUME_NONNULL_END
