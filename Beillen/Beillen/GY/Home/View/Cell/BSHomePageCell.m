//
//  BSHomePageCell.m
//  Beillen
//
//  Created by chenyi on 2026/8/15.
//

#import "BSHomePageCell.h"
#import "BSHomeModel.h"
#import "BSDeviceManager.h"


@interface BSHomePageCell()
/// 背景视图
@property (nonatomic, strong) UIView *contentBgView;

/// 设备背景视图
@property (nonatomic, strong) UIView *deviceBgView;
/// 设备 icon
@property (nonatomic, strong) UIImageView *deviceImage;
/// 设备名称
@property (nonatomic, strong) UILabel *deviceNameLabel;
/// 设备附文：
@property (nonatomic, strong) UILabel *deviceDetailLabel;

/// 电量 icon
@property (nonatomic, strong) UIImageView *deviceElect;
@property (nonatomic, strong) UILabel *deviceElectLabel;

/// 蓝牙背景视图
@property (nonatomic, strong) UIView *bleBgView;
/// 蓝牙 icon
@property (nonatomic, strong) UIImageView *deviceBleImg;
@property (nonatomic, strong) UILabel *deviceBleLabel;
@property (nonatomic, strong) UIImageView *deviceBleLeft;
@end


@implementation BSHomePageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    [self.contentView addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.contentBgView addSubview:self.deviceBgView];
    [self.deviceBgView addSubview:self.deviceImage];
    [self.deviceBgView addSubview:self.deviceNameLabel];
    [self.deviceBgView addSubview:self.deviceDetailLabel];
    [self.deviceBgView addSubview:self.deviceElect];
    [self.deviceBgView addSubview:self.deviceElectLabel];

//    [self.contentBgView addSubview:self.bleBgView];
//    [self.bleBgView addSubview:self.deviceBleImg];
//    [self.bleBgView addSubview:self.deviceBleLabel];
//    [self.bleBgView addSubview:self.deviceBleLeft];
    [self.deviceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.height.mas_equalTo(80);
    }];
//    [self.bleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(16);
//        make.left.mas_equalTo(17);
//        make.right.mas_equalTo(-17);
//        make.bottom.mas_equalTo(-17);
//    }];
    
    [self.deviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(64);
    }];
    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.deviceImage.mas_centerY).offset(-2);
        make.left.equalTo(self.deviceImage.mas_right).offset(24);
    }];
    [self.deviceDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deviceImage.mas_centerY).offset(2);
        make.left.equalTo(self.deviceNameLabel.mas_left).offset(0);
        make.right.mas_equalTo(16);;
    }];
    [self.deviceElect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.deviceNameLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(13);
        make.right.mas_equalTo(-55);
    }];
    [self.deviceElectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.deviceElect.mas_centerY).offset(0);
        make.left.equalTo(self.deviceElect.mas_right).offset(4);
        make.right.mas_equalTo(0);
    }];
    
    [self.contentBgView addSubview:self.bleBgView];
    [self.bleBgView addSubview:self.deviceBleImg];
    [self.bleBgView addSubview:self.deviceBleLabel];
    [self.bleBgView addSubview:self.deviceBleLeft];
//    [self.deviceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(17);
//        make.left.mas_equalTo(17);
//        make.right.mas_equalTo(-17);
//        make.height.mas_equalTo(80);
//    }];
    [self.bleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.equalTo(self.deviceBgView.mas_bottom).offset(16);
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.bottom.mas_equalTo(-17);
    }];
    [self.deviceBleImg mas_makeConstraints:^(MASConstraintMaker *make) {
 
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(13);
        make.bottom.mas_equalTo(-1);
    }];
    
    [self.deviceBleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deviceBleImg.mas_right).offset(8);
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self.deviceBleImg.mas_centerY).offset(0);
    }];
    
    [self.deviceBleLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(7.5);
        make.right.mas_equalTo(-1);
        make.centerY.equalTo(self.deviceBleImg.mas_centerY).offset(0);
    }];
    
}

/// 更新数据
- (void)updateDeviceModel:(BSHomeDeviceModel *)deviceModel{
    if (!deviceModel) return;
    if (![deviceModel isKindOfClass:[BSHomeDeviceModel class]]) {
        NSString *cls = [NSString stringWithFormat:@"HomePageCell deviceModel class :%@",NSStringFromClass(deviceModel.class)];
        NSLog(@"数据cell报错=====%@",cls);
        return;
    }
    self.deviceModel = deviceModel;
    BSCommonDevice *device = [[BSDeviceManager shareInstance] findDeviceWithIdentifier:deviceModel.sn];
    BOOL bleConnected = device.isConnected; // 蓝牙连接
    // ---> 设备名称
    self.deviceNameLabel.text =  deviceModel.name;
    self.deviceDetailLabel.text =  deviceModel.detailName;
    
  
//    self.deviceElect.hidden = self.deviceElectLabel.hidden = !bleConnected;
    
    self.deviceElectLabel.text  = [NSString stringWithFormat:@"%@W",@(deviceModel.power)];
    if (bleConnected) {
        self.deviceBleLabel.text = NSLocalizedStringkey(@"蓝牙已连接");
    } else {
        self.deviceBleLabel.text = NSLocalizedStringkey(@"蓝牙已断开");
    }
    
}


- (UIView *)contentBgView {
    if (!_contentBgView) {
        UIView* view = [UIView new];
        
       
        view.backgroundColor = bsColorString(@"#FFFFFF");
        
    
        view.layer.shadowColor = bsColorAlphaString(@"#000000", 0.05).CGColor;
        view.layer.shadowOffset = CGSizeMake(0,1);
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowRadius = 2;
        CALayer *layer1 = [CALayer new];
        layer1.backgroundColor = bsColorAlphaString(@"#010101", 0.05).CGColor;
        layer1.bounds = view.bounds;
        layer1.position = view.center;
        [view.layer addSublayer:layer1];
        view.layer.cornerRadius = 32;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor colorWithRed:0.773 green:0.769 blue:0.859 alpha:0.3].CGColor;
//        view.layer.borderColor = UIColor(red: 0.773, green: 0.769, blue: 0.859, alpha: 0.3).cgColor;
        _contentBgView = view;
    }
    return _contentBgView;
}

- (UIView *)deviceBgView {
    if (!_deviceBgView) {
        UIView* view = [UIView new];
        _deviceBgView = view;
    }
    return _deviceBgView;
}


- (UIImageView *)deviceImage {
    if (!_deviceImage) {
        _deviceImage = [UIImageView new];
        _deviceImage.image = [UIImage imageNamed:@"home_device_icon"];
        _deviceImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _deviceImage;
}

- (UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [UILabel new];
        _deviceNameLabel.font = bsFontBold(20);
        _deviceNameLabel.textColor = bsColorString(@"#191C1E");
//        _deviceNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _deviceNameLabel;
}
- (UILabel *)deviceDetailLabel {
    if (!_deviceDetailLabel) {
        _deviceDetailLabel = [UILabel new];
        _deviceDetailLabel.font = bsFontMedium(16);
        _deviceDetailLabel.textColor = bsColorString(@"#454558");
//        _deviceDetailLabel.textAlignment = NSTextAlignmentCenter;
        _deviceDetailLabel.numberOfLines = 1;
    }
    return _deviceDetailLabel;
}

- (UIImageView *)deviceElect {
    if (!_deviceElect) {
        _deviceElect = [UIImageView new];
        _deviceElect.image = [UIImage imageNamed:@"home_device_elect"];
        _deviceElect.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _deviceElect;
}

- (UILabel *)deviceElectLabel {
    if (!_deviceElectLabel) {
        _deviceElectLabel = [UILabel new];
        _deviceElectLabel.font = bsFontBold(22);
        _deviceElectLabel.textColor = bsColorString(@"#004098");
//        _deviceNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _deviceElectLabel;
}

- (UIView *)bleBgView {
    if (!_bleBgView) {
        UIView* view = [UIView new];
        _bleBgView = view;
    }
    return _bleBgView;
}


- (UIImageView *)deviceBleImg {
    if (!_deviceBleImg) {
        _deviceBleImg = [UIImageView new];
        _deviceBleImg.image = [UIImage imageNamed:@"home_device_ble"];
        _deviceBleImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _deviceBleImg;
}

- (UILabel *)deviceBleLabel {
    if (!_deviceBleLabel) {
        _deviceBleLabel = [UILabel new];
        _deviceBleLabel.font = bsFontMedium(14);
        _deviceBleLabel.textColor = bsColorString(@"#454558");

    }
    return _deviceBleLabel;
}

- (UIImageView *)deviceBleLeft {
    if (!_deviceBleLeft) {
        _deviceBleLeft = [UIImageView new];
        _deviceBleLeft.image = [UIImage imageNamed:@"home_device_letf"];
        _deviceBleLeft.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _deviceBleLeft;
}

@end
