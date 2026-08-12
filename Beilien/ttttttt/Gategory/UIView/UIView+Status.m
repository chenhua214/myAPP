//
//  UIView+Status.m
//  BatteryStation
//
//  Created by immotor on 2019/4/22.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "UIView+Status.h"

@interface UIView ()

@property (nonatomic,strong) UIView *vg_progress;
@property (nonatomic,strong) UIView *vg_failed;
@property (nonatomic,strong) UIView *vg_empty;

@end

//Key
static void *KeyVgProgress=(void*)@"KeyVgProgress";
static void *KeyVgFailed=(void*)@"KeyVgFailed";
static void *KeyVgEmpty=(void*)@"KeyVgEmpty";

#define kDefaultContentViewTag 20210809

@implementation UIView(Status)

#pragma mark 属性

-(void)setVg_progress:(UIView *)vg_progress{
    objc_setAssociatedObject(self, KeyVgProgress, vg_progress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)vg_progress{
    return objc_getAssociatedObject(self, KeyVgProgress);
}

-(void)setVg_failed:(UIView *)vg_failed{
    objc_setAssociatedObject(self, KeyVgFailed, vg_failed, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)vg_failed{
    return objc_getAssociatedObject(self, KeyVgFailed);
}

-(void)setVg_empty:(UIView *)vg_empty{
    objc_setAssociatedObject(self, KeyVgEmpty, vg_empty, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)vg_empty{
    return objc_getAssociatedObject(self, KeyVgEmpty);
}

#pragma mark 方法

- (void)status_progress{
    [self status_success];

    self.vg_progress=[[UIView alloc]init];
    [self addSubview:self.vg_progress];
    [self.vg_progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];

    UIActivityIndicatorView *aiv=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [aiv setColor:[UIColor grayColor]];
    [aiv startAnimating];
    [self.vg_progress addSubview:aiv];
    [aiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.vg_progress);
    }];
}

-(void)status_failed:(NSString *)reason target:(id)target selector:(SEL)selector{
    [self status_success];

    self.vg_failed=[[UIView alloc]init];
    [self addSubview:self.vg_failed];
    [self.vg_failed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 36, 0, 36));
        make.center.equalTo(self);
    }];


    if (reason.length) {
        UIButton *btn=[[UIButton alloc]init];
        [self.vg_failed addSubview:btn];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedStringkey(@"no_network")  attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:1.0]}];
        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:141/255.0 blue:89/255.0 alpha:1.0]} range:NSMakeRange(6, 2)];

        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        [btn setAttributedTitle:string forState:UIControlStateNormal];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size: 14]};  //指定字号
        CGRect rect = [NSLocalizedStringkey(@"no_network")  boundingRectWithSize:CGSizeMake(MAXFLOAT, 16)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:dic context:nil];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@25);
            make.width.equalTo(@(rect.size.width));
            make.top.equalTo(self.vg_failed);
            make.bottom.centerX.equalTo(self.vg_failed);
        }];
        UIImageView *iv_tip = [[UIImageView alloc] init];
        iv_tip.image = [UIImage imageNamed:@"fail_imageIcon"];
        [self.vg_failed addSubview:iv_tip];
        [iv_tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btn.mas_top);
            make.centerX.equalTo(btn);
            make.width.equalTo(@(160));
            make.height.equalTo(@(100));
        }];
    }
}

- (void)status_empty:(NSString *)text imageName:(NSString *)imageName{
    [self status_success];

    self.vg_empty = [[UIView alloc]init];

    UIView *superView = self;
    if([self isKindOfClass:[UIScrollView class]]){
        //处理scrollview 约束问题
        NSInteger tag = kDefaultContentViewTag;
        UIView *contentView = [self viewWithTag:tag];
        if (!contentView) {
            contentView = [UIView new];
            contentView.tag = kDefaultContentViewTag;
        }
        [contentView addSubview:self.vg_empty];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.center.equalTo(self);
            make.height.mas_equalTo(self.mas_height);
        }];
        superView = contentView;
    }else{
        [self addSubview:self.vg_empty];
    }

    [self.vg_empty mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superView).insets(UIEdgeInsetsMake(0, 36, 0, 36));
        make.centerY.equalTo(superView.mas_centerY);
    }];

    UILabel *lb=[[UILabel alloc]init];
    [lb setNumberOfLines:0];
    [lb setFont:[UIFont bs_regularFontWithFontSize:16]];
    lb.textColor = [UIColor bs_colorFromARGB:@"#000000" alpha:0.5];
    [lb setTextAlignment:NSTextAlignmentCenter];
    [lb setText:text];
    [self.vg_empty addSubview:lb];

    BOOL hasImage = imageName && imageName.length > 0;
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!hasImage) {
            make.edges.equalTo(self.vg_empty);
        }else{
            make.left.right.bottom.equalTo(self.vg_empty);
        }
    }];
    if (hasImage){
        UIImageView *iv_tip = [[UIImageView alloc] init];
        iv_tip.image = [UIImage imageNamed:imageName];
        [self.vg_empty addSubview:iv_tip];
        [iv_tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vg_empty);
            make.bottom.equalTo(lb.mas_top).offset(-23);
            make.centerX.equalTo(lb);
        }];
    }
}

- (void)status_success{
    //去除所有状态控制相关控件
    [self.vg_progress removeFromSuperview];
    self.vg_progress = nil;

    [self.vg_failed removeFromSuperview];
    self.vg_failed = nil;

    if (self.vg_empty.superview && self.vg_empty ) {
        [self.vg_empty.superview removeFromSuperview];
    }
    UIView *contentView = [self viewWithTag:kDefaultContentViewTag];
    if (contentView) {
        [contentView removeFromSuperview];
        contentView = nil;
    }
    [self.vg_empty removeFromSuperview];
    self.vg_empty=nil;
}

@end

