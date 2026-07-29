

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BSRoundCorner)

///Color生成一张图片
+ (UIImage*)bs_imageWithColor:(UIColor*)color;

///带圆角背景图  resizableImageWithCapInsets 裁剪 @param color 颜色 @param cornerRadius 圆角
+ (instancetype)bs_imageWithColor:(UIColor *)color
                      cornerRadius:(CGFloat)cornerRadius;

/// 圆角背景图 @param color 颜色 @param size 大小
+ (instancetype)bs_imageWithColor:(UIColor *)color
                              size:(CGSize)size;

/// 圆角图片 @param color 颜色 @param borderColor 边框颜色 @param size 大小 @param cornerRadius 圆角 @param borderWidth 边框宽度
+ (UIImage *)bs_imageWithColor:(UIColor *)color
                    borderColor:(UIColor *)borderColor
                           size:(CGSize)size
                   cornerRadius:(CGFloat)cornerRadius
                    borderWidth:(CGFloat)borderWidth;

/// 带圆角的纯颜色背景图 @param color 颜色 @param size 大小 @param cornerradius 圆角
+ (instancetype)bs_imageWithColor:(UIColor *)color
                              size:(CGSize)size
                      cornerRadius:(CGFloat)cornerradius;

/// 圆角border @param borderColor 边框颜色 @param borderWidth 边框宽度 @param corradius 圆角大小 @param size 大小
- (UIImage *)bs_imageWithBorderColor:(UIColor *)borderColor
                          borderWidth:(CGFloat)borderWidth
                         cornerRadius:(CGFloat)corradius
                                 size:(CGSize)size;

/// 图片圆角 @param cornerradius 圆角大小 @param size 大小
- (UIImage *)bs_imageWithCornerRadius:(CGFloat)cornerradius
                                  size:(CGSize)size;

/// 图片填充到大小 @param size 大小
- (nullable UIImage *)bs_imageByResizeToSize:(CGSize)size;

/// 图片保持比例不变 裁剪成固定宽度 @param width 宽度 @param minHeight 最小高度
- (nullable UIImage *)bs_imageByResizeWithWidth:(CGFloat)width
                                      minHeight:(CGFloat)minHeight;

///图片内所 @param insets 内缩 @param color 颜色
- (nullable UIImage *)bs_imageByInsetEdge:(UIEdgeInsets)insets
                                withColor:(nullable UIColor *)color;

///生成渐变色背景图 @param colors 渐变颜色数组 @param size 大小 @param cornerRadius 圆角 @param startPoint 开始位置 @param endPoint 结束位置
+ (UIImage *)bs_gradientImageWithColors:(NSArray *)colors
                                    size:(CGSize)size
                            cornerRadius:(CGFloat)cornerRadius
                              startPoint:(CGPoint)startPoint
                                endPotin:(CGPoint)endPoint;

/// 生成一张多圆角的图 @param radius 圆角 @param corners 边角 @param borderWidth 边框宽度 @param borderColor 边框颜色 @param borderLineJoin 图形环境和接合点类型
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin;


/// 生成不同原角的图片
- (UIImage *)roundImageWithLeftTopCorner:(CGFloat)leftTop
                          rightTopCorner:(CGFloat)rigtTop
                        bottomLeftCorner:(CGFloat)bottemLeft
                       bottomRightCorner:(CGFloat)bottemRight;

///view生成一张图片 @param view 视图view
+ (UIImage*)bs_imageWithUIView:(UIView*)view;

///Color生成一张默认的预加载图片
+ (UIImage*)bs_defaultLoadingImagesize:(CGSize)size ;

/// 获取视频第一帧image
/// 此方法可能会造成卡顿
+ (UIImage *)synchImageWithVideoPath:(NSURL *)path;
/// 获取视频第一帧image
+ (void)asynchImageWithVideoPath:(NSURL *)path handle:(void (^)(BOOL state,UIImage *image))handle;

/// 使用NSData 转换一个 UIIage
+ (UIImage *)imageWithImgData:(NSData *)data;

/// 转换图片到目标大小
+ (UIImage *)cp_imageFromImage:(UIImage *)image size:(CGSize)size;

/// 压缩图片到指定大小、指令压缩不足就压缩
+ (NSData *)cp_imageFromImage:(UIImage *)image maxLength:(float)maxLength;

@end

NS_ASSUME_NONNULL_END
