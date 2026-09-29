//
//  BSBaseButton.h
//  BaseusAPP
//
//  Created by skychi on 2022/5/26.
//  Copyright © 2022 Baseus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 图片和文字的相对位置
typedef NS_ENUM(NSInteger, BSBaseButtonImagePosition) {
    BSBaseButtonImagePositionTop,     // 图片在文字顶部
    BSBaseButtonImagePositionLeft,    // 图片在文字左侧
    BSBaseButtonImagePositionBottom,  // 图片在文字底部
    BSBaseButtonImagePositionRight,   // 图片在文字右侧
    BSBaseButtonImagePositionCenter   // 无文字,图片居中,或无图片,文字居中
};

@interface BSBaseButton : UIButton
/// 图片文字间距
@property (nonatomic,assign) CGFloat itemSpacing;
/// 图片和文字的相对位置
@property (nonatomic,assign) BSBaseButtonImagePosition imagePosition;
@property (nonatomic,assign) CGSize imageSize;
@end

NS_ASSUME_NONNULL_END
