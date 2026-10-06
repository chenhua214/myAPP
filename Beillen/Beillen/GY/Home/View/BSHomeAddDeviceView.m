//
//  BSHomeAddDeviceView.m
//  Beillen
//
//  Created by chenyi on 2026/8/14.
//

#import "BSHomeAddDeviceView.h"


@interface BSHomeAddDeviceView()

@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UIImageView *imageBgView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation BSHomeAddDeviceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageBgView];
        [self addSubview:self.imageView];
        [self addSubview:self.detailLab];
      
        [self.imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
           
        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25.0, 25.0));
            make.centerX.mas_equalTo(0);
            make.bottom.equalTo(self.mas_centerY);
        }];
        [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(self.imageView.mas_bottom).offset(8);
        }];
    }
    return self;
}

/// 切换语言、更新内容
- (void)updateOnChangeLanguages
{
    self.detailLab.text = NSLocalizedStringkey(@"add_devices_tit");
}

-(UILabel*)detailLab {
    if (!_detailLab) {
        UILabel *label = [UILabel new];
        label.text = NSLocalizedStringkey(@"add_devices_tit");
        label.font = bsFontMedium(14);
        label.textColor = [UIColor bs_colorFromARGB:@"#454558" alpha:0.6];
        _detailLab = label;
    }
    return _detailLab;
}

-(UIImageView*)imageBgView {
    if (!_imageBgView) {
        UIImageView *imageBgView = [UIImageView new];
        imageBgView.image = [UIImage imageNamed:@"home_add_icon"];
        _imageBgView = imageBgView;
    }
    return _imageBgView;
}

-(UIImageView*)imageView {
    if (!_imageView) {
        UIImageView *imageBgView = [UIImageView new];
        imageBgView.image = [UIImage imageNamed:@"home_add_devices"];
        _imageView = imageBgView;
    }
    return _imageView;
}

@end
