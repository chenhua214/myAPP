#import "UIImage+BSRoundCorner.h"
#import <AVFoundation/AVFoundation.h>
@implementation UIImage (ZLJRoundCorner)

+ (UIImage*)bs_imageWithColor:(UIColor*)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)bs_imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    CGSize cornerSize = CGSizeMake(cornerRadius*2 , cornerRadius*2  );
    UIImage *image = [self bs_imageWithColor:color size:cornerSize cornerRadius:cornerRadius];
    // 进行拉边适配
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius) resizingMode:UIImageResizingModeStretch];
    return image;
}

+ (instancetype)bs_imageWithColor:(UIColor *) color size:(CGSize) size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    if (![self sizeAviled:size]) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (UIImage *)bs_imageWithColor:(UIColor *)color borderColor:(UIColor *)borderColor size:(CGSize)size cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth {
    UIImage *image = [self bs_imageWithColor:color size:size cornerRadius:cornerRadius];
    return [image bs_imageWithBorderColor:borderColor borderWidth:borderWidth cornerRadius:cornerRadius size:size];
}

+ (instancetype)bs_imageWithColor:(UIColor *)color size:(CGSize)size   cornerRadius:(CGFloat)cornerradius {
    
    UIImage *image = [self bs_imageWithColor:color size:size];
    image = [image bs_imageWithCornerRadius:cornerradius size:size];
    return image;
}

- (UIImage *)bs_imageWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)corradius size:(CGSize)size{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    if (![[self class] sizeAviled:size]) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGFloat cornerRadius = corradius;
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:cornerRadius] addClip];
    [self drawInRect:rect];
    //    CGPoint center = CGPointMake(size.width * 0.5, size.height * 0.5);
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:corradius];
    rectPath.lineWidth = borderWidth;
    [borderColor setStroke];
    [rectPath stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)bs_imageWithCornerRadius:(CGFloat)cornerradius size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    if (![[self class] sizeAviled:size]) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerradius] addClip];
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)bs_imageByResizeToSize:(CGSize)size {
    if (![[self class] sizeAviled:size]) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (nullable UIImage *)bs_imageByResizeWithWidth:(CGFloat)width minHeight:(CGFloat)minHeight{
    if(width == 0) {
        return nil;
    }
    CGFloat scale = self.size.width / width;
    CGSize newSize = CGSizeMake(width, ceil(MAX( self.size.height / scale, minHeight)));
    return [self bs_imageByResizeToSize:newSize];
}

- (UIImage *)bs_imageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color {
    CGSize size = self.size;
    size.width -= insets.left + insets.right;
    size.height -= insets.top + insets.bottom;
    if (size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(-insets.left, -insets.top, self.size.width, self.size.height);
    if (![[self class] sizeAviled:size]) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (color) {
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        CGPathAddRect(path, NULL, rect);
        CGContextAddPath(context, path);
        CGContextEOFillPath(context);
        CGPathRelease(path);
    }
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)bs_gradientImageWithColors:(NSArray *)colors size:(CGSize)size cornerRadius:(CGFloat)cornerRadius startPoint:(CGPoint)startPoint endPotin:(CGPoint)endPoint
{
    if (![self sizeAviled:size]) return nil;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    if (!colors.count || CGRectEqualToRect(rect, CGRectZero)) {
        return nil;
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = rect;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.cornerRadius = cornerRadius;
    NSMutableArray *mutColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [mutColors addObject:(__bridge id)color.CGColor];
    }
    gradientLayer.colors = [NSArray arrayWithArray:mutColors];
    
    UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, gradientLayer.opaque, 0);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

// 多圆角绘图
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    if (![[self class] sizeAviled:self.size]) return nil;
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)roundImageWithLeftTopCorner:(CGFloat)leftTop
                    rightTopCorner:(CGFloat)rigtTop
                  bottomLeftCorner:(CGFloat)bottemLeft
                 bottomRightCorner:(CGFloat)bottemRight {
    
    if (![[self class] sizeAviled:self.size]) return nil;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    maskPath.lineWidth = 1.0;
    maskPath.lineCapStyle = kCGLineCapRound;
    maskPath.lineJoinStyle = kCGLineJoinRound;
    [maskPath moveToPoint:CGPointMake(rigtTop, height)]; //左下角
    [maskPath addLineToPoint:CGPointMake(width - rigtTop, height)];
    
    [maskPath addQuadCurveToPoint:CGPointMake(width, height- rigtTop) controlPoint:CGPointMake(width, height)]; //右下角的圆弧
    [maskPath addLineToPoint:CGPointMake(width, bottemRight)]; //右边直线
    
    [maskPath addQuadCurveToPoint:CGPointMake(width - bottemRight, 0) controlPoint:CGPointMake(width, 0)]; //右上角圆弧
    [maskPath addLineToPoint:CGPointMake(bottemLeft, 0)]; //顶部直线
    
    [maskPath addQuadCurveToPoint:CGPointMake(0, bottemLeft) controlPoint:CGPointMake(0, 0)]; //左上角圆弧
    [maskPath addLineToPoint:CGPointMake(0, height - leftTop)]; //左边直线
    [maskPath addQuadCurveToPoint:CGPointMake(leftTop, height) controlPoint:CGPointMake(0, height)]; //左下角圆弧
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    [maskPath closePath];
    CGContextSaveGState(context);
    [maskPath addClip];
    CGContextDrawImage(context, rect, self.CGImage);
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}


+ (void)setCornerWithLeftTopCorner:(CGFloat)leftTop
                    rightTopCorner:(CGFloat)rigtTop
                  bottomLeftCorner:(CGFloat)bottemLeft
                 bottomRightCorner:(CGFloat)bottemRight
                              view:(UIView *)view
                             frame:(CGRect)frame {
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    maskPath.lineWidth = 1.0;
    maskPath.lineCapStyle = kCGLineCapRound;
    maskPath.lineJoinStyle = kCGLineJoinRound;
    [maskPath moveToPoint:CGPointMake(bottemRight, height)]; //左下角
    [maskPath addLineToPoint:CGPointMake(width - bottemRight, height)];
    
    [maskPath addQuadCurveToPoint:CGPointMake(width, height- bottemRight) controlPoint:CGPointMake(width, height)]; //右下角的圆弧
    [maskPath addLineToPoint:CGPointMake(width, rigtTop)]; //右边直线
    
    [maskPath addQuadCurveToPoint:CGPointMake(width - rigtTop, 0) controlPoint:CGPointMake(width, 0)]; //右上角圆弧
    [maskPath addLineToPoint:CGPointMake(leftTop, 0)]; //顶部直线
    
    [maskPath addQuadCurveToPoint:CGPointMake(0, leftTop) controlPoint:CGPointMake(0, 0)]; //左上角圆弧
    [maskPath addLineToPoint:CGPointMake(0, height - bottemLeft)]; //左边直线
    [maskPath addQuadCurveToPoint:CGPointMake(bottemLeft, height) controlPoint:CGPointMake(0, height)]; //左下角圆弧

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}


+ (UIImage*)bs_imageWithUIView:(UIView*)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

+ (UIImage*)bs_defaultLoadingImagesize:(CGSize)size
{
    UIColor *statColor = [UIColor bs_colorFromARGB:@"#ffffff"] ;
    UIColor *endColor = [UIColor bs_colorFromARGB:@"#7b7b7b"] ;
    NSArray *arrColor = [[NSArray alloc]initWithObjects:statColor,endColor, nil ];
    UIImage * image = [UIImage bs_gradientImageWithColors:arrColor size:size cornerRadius:0 startPoint:CGPointMake(0.5, 0) endPotin:CGPointMake(0.5, 1)] ;
  
    return image;
}


/// 获取视频第一帧image
/// 此方法可能会造成卡顿
+ (UIImage *)synchImageWithVideoPath:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

/// 获取视频第一帧image
+ (void)asynchImageWithVideoPath:(NSURL *)path handle:(void (^)(BOOL state, UIImage *image))handle
{
    if (!handle) return;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    [assetGen generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:time]] completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
            handle(YES,videoImage);
        } else {
            handle(NO,nil);
        }
    }];
}

/// 判断size是否包含0
+ (BOOL)sizeAviled:(CGSize)size {
    return (size.width > 0 && size.height > 0);
}


/// 使用NSData 转换一个 UIIage
+ (UIImage *)imageWithImgData:(NSData *)data
{
    // 创建 CGImageSourceRef
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    UIImage *image;
    if (source != NULL) {
        NSDictionary *options = @{
            (__bridge NSString *)kCGImageSourceShouldCache: @NO,
            (__bridge NSString *)kCGImageSourceShouldAllowFloat: @NO
        };
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, (__bridge CFDictionaryRef)options);
        image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];

        // 记得释放资源
        CFRelease(imageRef);
        CFRelease(source);
    }
    return image;
}

/// 转换图片到目标大小
+ (UIImage *)cp_imageFromImage:(UIImage *)image size:(CGSize)size
{
    // 设置目标大小
    CGSize targetSize = size; // 例如，目标大小为480x800像素
    // 开始一个基于位图的图形上下文，大小为目标大小
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 1.0);
    // 在目标大小的矩形中绘制原始图像
    [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    // 从图形上下文中获取新的缩放后的图像
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


/// 压缩图片到指定大小、指令压缩不足就压缩
///
/// 函数cp_imageFromImage:接受两个参数：一个是UIImage对象image，另一个是最大长度maxLength，表示压缩后NSData的最大长度。它的主要作用可以分为两个步骤：按质量压缩和按尺寸压缩。
/// 1. 按质量压缩部分：
///
///   · 首先尝试使用UIImageJPEGRepresentation函数将UIImage对象转换为JPEG格式的NSData，压缩质量初始设为1（即最佳质量）。
///   · 如果转换后的NSData长度小于maxLength，则直接返回这个数据，不需要进一步压缩。
///   · 如果长度超过了maxLength，则使用二分法进行调整压缩质量：
///      1. 设置一个压缩质量的上限（max）和下限（min），初始分别为1和0。
///      2. 通过二分法找到一个合适的压缩质量，使得压缩后的NSData长度在maxLength的90%到100%之间。
///      3. 如果找到合适的压缩质量，即使得NSData长度在可接受范围内，则结束循环。
///
/// 2. 按尺寸压缩部分：
///
///   · 如果按质量压缩后的NSData长度仍超过maxLength，则进行按尺寸压缩。
///      1. 进入一个循环，直到NSData长度小于等于maxLength或者在一次循环中未能减小NSData的长度（即达到压缩极限）为止。
///      2. 在每次循环中，计算新的尺寸，将原始图像缩放到这个尺寸，并将缩放后的图像再次转换为JPEG格式的NSData。
///      3. 函数返回最终压缩后的NSData，其大小不超过maxLength。这段代码适用于需要在保持图像质量的前提下，控制图像NSData大小的场景，例如上传图片到服务器或者存储图像时的优化处理。
+ (NSData *)cpAndSize_imageFromImage:(UIImage *)image maxLength:(float)maxLength
{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}


@end
