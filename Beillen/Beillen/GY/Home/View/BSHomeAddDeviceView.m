//
//  BSHomeAddDeviceView.m
//  Beillen
//
//  Created by chenyi on 2026/8/14.
//

#import "BSHomeAddDeviceView.h"


@interface BSHomeAddDeviceView()

@property (nonatomic, strong) UILabel *detailLab;

@end

@implementation BSHomeAddDeviceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"home_add_devices"];
        [self addSubview:imageView];
        
        UILabel *label = [UILabel new];
        label.text = NSLocalizedStringkey(@"add_devices_tit");
        label.font = bsFontMedium(14);
        label.textColor = bsColorString(@"#45455899");
        [self addSubview:label];
        self.detailLab = label;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(imageView.mas_bottom).offset(bsValue(16));
        }];
    }
    return self;
}


/// 切换语言、更新内容
- (void)updateOnChangeLanguages
{
    self.detailLab.text = NSLocalizedStringkey(@"add_devices_tit");
}


@end
