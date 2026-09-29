//
//  BSBaseButton.m
//  BaseusAPP
//
//  Created by skychi on 2022/5/26.
//  Copyright © 2022 Baseus. All rights reserved.
//

#import "BSBaseButton.h"

@implementation BSBaseButton

#pragma mark - Life cycle

+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    BSBaseButton *button = [super buttonWithType:buttonType];
    [button setup];
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    [self resetSubViews];
    if(!self.currentImage || !self.currentTitle || self.currentTitle.length == 0){
        _imagePosition = BSBaseButtonImagePositionCenter;
    }
    if (self.imagePosition == BSBaseButtonImagePositionLeft) {
        // 图片在左侧
        [self layoutSubViewsForImagePositionLeft];
    } else if (self.imagePosition == BSBaseButtonImagePositionRight) {
        // 图片在右侧:
        [self layoutSubViewsForImagePositionRight];
    } else if (self.imagePosition == BSBaseButtonImagePositionTop) {
        // 图片在顶部
        [self layoutSubViewsForImagePositionTop];
    } else if (self.imagePosition == BSBaseButtonImagePositionBottom) {
        // 图片在底部
        [self layoutSubViewsForImagePositionBottom];
    }else if (self.imagePosition == BSBaseButtonImagePositionCenter){
        // 图片或文字在中心点
        [self layoutSubViewsForImagePositionCenter];
    }
}

#pragma mark- setup

- (void)setup {
    _imageSize   = CGSizeZero;
    _itemSpacing = 4;
    _imagePosition = BSBaseButtonImagePositionLeft;
}

#pragma mark- Private methods

/// 计算尺寸
- (void)resetSubViews {
    self.imageView.size = CGSizeEqualToSize(_imageSize, CGSizeZero) ? self.imageView.image.size : _imageSize ;
    [self.titleLabel sizeToFit];
    // 图片在右侧 或左侧
    if (self.imagePosition == BSBaseButtonImagePositionRight || self.imagePosition == BSBaseButtonImagePositionLeft) {
        if (self.titleLabel.width > (self.width - self.itemSpacing - self.imageView.width)) {
            self.titleLabel.width = self.width;
        }
    } else if (self.imagePosition == BSBaseButtonImagePositionTop || self.imagePosition == BSBaseButtonImagePositionBottom) {
        // 图片在顶部/底部
        if (self.titleLabel.width > self.width) {
            self.titleLabel.width = self.width;
        }
    }
}

/// 图片在左侧
- (void)layoutSubViewsForImagePositionLeft {
    if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {   // 整体靠右
        self.titleLabel.x = self.width - self.titleLabel.width;
        self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;

        self.imageView.x = self.width - self.titleLabel.width - self.itemSpacing - self.imageView.width;
        self.imageView.y = (self.height - self.imageView.height) * 0.5;

    } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) { // 整体靠左
        self.imageView.x = 0;
        self.imageView.y = (self.height - self.imageView.height) * 0.5;

        self.titleLabel.x = self.imageView.right + self.itemSpacing;
        self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;

    } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentCenter) { // 整体居中
        self.imageView.x = self.width * 0.5 - (self.titleLabel.width + self.itemSpacing + self.imageView.width) * 0.5;
        self.imageView.y = (self.height - self.imageView.height) * 0.5;

        self.titleLabel.x = self.itemSpacing + self.imageView.right;
        self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;
    }
}

/// 图片在右侧
- (void)layoutSubViewsForImagePositionRight {
    if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {   // 整体靠右

        self.imageView.x = self.width - self.imageView.width;
        self.imageView.y = (self.height - self.imageView.height) * 0.5;

        self.titleLabel.x = self.width - self.imageView.width - self.itemSpacing - self.titleLabel.width;
        self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;

    } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) { // 整体靠左
        self.titleLabel.x = 0;
        self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;

        self.imageView.x = self.itemSpacing + self.titleLabel.width;
        self.imageView.y = (self.height - self.imageView.height) * 0.5;

    } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentCenter) { // 整体居中
        self.titleLabel.x = self.width * 0.5 - (self.titleLabel.width + self.itemSpacing + self.imageView.width) * 0.5;
        self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;

        self.imageView.x = self.titleLabel.x + self.titleLabel.width + self.itemSpacing;
        self.imageView.y = (self.height - self.imageView.height) * 0.5;
    }
}

/// 图片在顶部
- (void)layoutSubViewsForImagePositionTop {
    if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop) {  // 整体靠顶部

        self.imageView.y = 0;
        self.imageView.centerX = self.width * 0.5;

        self.titleLabel.y = self.imageView.bottom + self.itemSpacing;
        self.titleLabel.centerX = self.width * 0.5;

    } else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom) { // 整体靠底部

        self.titleLabel.y = self.height - self.titleLabel.height;
        self.titleLabel.centerX = self.width * 0.5;

        self.imageView.y = self.height - (self.imageView.height + self.titleLabel.height + self.itemSpacing);
        self.imageView.centerX = self.width * 0.5;

    } else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentCenter) { // 整体居中
        self.imageView.y = self.height * 0.5 - (self.imageView.height + self.titleLabel.height + self.itemSpacing) * 0.5;
        self.imageView.centerX = self.width * 0.5;

        self.titleLabel.y = self.imageView.bottom + self.itemSpacing;
        self.titleLabel.centerX = self.width * 0.5;
    }
}

/// 图片在底部
- (void)layoutSubViewsForImagePositionBottom {
    if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop) {  // 整体靠顶部

        self.titleLabel.y = 0;
        self.titleLabel.centerX = self.width * 0.5;

        self.imageView.y = self.titleLabel.bottom + self.itemSpacing;
        self.imageView.centerX = self.width * 0.5;

    } else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom) { // 整体靠底部

        self.imageView.y = self.height - self.imageView.height;
        self.imageView.centerX = self.width * 0.5;

        self.titleLabel.y = self.height - (self.titleLabel.height + self.itemSpacing + self.imageView.height);
        self.titleLabel.centerX = self.width * 0.5;

    } else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentCenter) { // 整体居中

        self.titleLabel.y = self.height * 0.5 - (self.imageView.height + self.titleLabel.height + self.itemSpacing) * 0.5;
        self.titleLabel.centerX = self.width * 0.5;

        self.imageView.y = self.titleLabel.bottom + self.itemSpacing;
        self.imageView.centerX = self.width * 0.5;

    }
}

- (void)layoutSubViewsForImagePositionCenter{
    if (!self.currentImage) {
        // 居中
        self.titleLabel.centerX = self.width * 0.5;
        self.titleLabel.centerY = self.height * 0.5;
    } else if (!self.currentTitle || self.currentTitle.length == 0) {
        // 居中
        self.imageView.centerX = self.width * 0.5;
        self.imageView.centerY = self.height * 0.5;
    }
}

#pragma mark - Setter

- (void)setImagePosition:(BSBaseButtonImagePosition)imagePosition {
    _imagePosition = imagePosition;
    [self setNeedsLayout];
}

- (void)setItemSpacing:(CGFloat)itemSpacing{
    _itemSpacing = itemSpacing;
    [self setNeedsLayout];
}

@end
