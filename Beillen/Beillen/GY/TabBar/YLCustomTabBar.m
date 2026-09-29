//
//  YLCustomTabBar.m
//  Beillen
//
//  Created by chenyi on 2026/9/26.
//

#import "YLCustomTabBar.h"

#import <objc/runtime.h>
#import "BSBaseButton.h"

@interface YLCustomTabBar ()
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemButtons;
@property (nonatomic, strong) UIVisualEffectView *blurView; // 毛玻璃背景
@end

@implementation YLCustomTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.itemButtons = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        
        // 1. 添加阴影效果 (悬浮感的关键)
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 4);
        self.layer.shadowRadius = 20;
        self.layer.shadowOpacity = 0.15;
        self.layer.cornerRadius = 30; // 圆角
        // 注意：blurView 不应拦截点击事件，或者将按钮加在 blurView 之上
        self.blurView.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setupItemsWithTitles:(NSArray<NSString *> *)titles
              normalImages:(NSArray<NSString *> *)normalImages
            selectedImages:(NSArray<NSString *> *)selectedImages {
    
    CGFloat count = titles.count;
    CGFloat width = self.bounds.size.width / count;
    CGFloat height = self.bounds.size.height;
    
    for (int i = 0; i < count; i++) {
        BSBaseButton *btn = [BSBaseButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        
        // 设置图片
        UIImage *normalImg = [[UIImage imageNamed:normalImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectImg = [[UIImage imageNamed:selectedImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [btn setImage:normalImg forState:UIControlStateNormal];
        [btn setImage:selectImg forState:UIControlStateSelected];
        NSString* titleStr = titles[i];
        [btn setTitle:titleStr forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor bs_colorFromARGB:@"#454558" alpha:0.6] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor bs_colorFromARGB:@"#004098"] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont bs_semiboldFontWithFontSize:12.0];
        
        // 布局按钮
        btn.frame = CGRectMake(i * width, 0, width, height);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.itemSpacing = 1;
        btn.imagePosition =  BSBaseButtonImagePositionTop ;
       
        // 将按钮添加到 blurView 之上，确保可点击
        [self addSubview:btn];
        [self.itemButtons addObject:btn];
    }
    
    // 默认选中第一个
    if (self.itemButtons.count > 0) {
        self.selectedIndex = 0;
        ((UIButton *)self.itemButtons[0]).selected = YES;
    }
}

- (void)btnClick:(UIButton *)sender {
    // 重置所有按钮状态
    for (UIButton *btn in self.itemButtons) {
        btn.selected = NO;
    }
    sender.selected = YES;
    self.selectedIndex = sender.tag;
    
    if ([self.delegate respondsToSelector:@selector(floatingTabBarDidSelectIndex:)]) {
        [self.delegate floatingTabBarDidSelectIndex:sender.tag];
    }
}

@end
