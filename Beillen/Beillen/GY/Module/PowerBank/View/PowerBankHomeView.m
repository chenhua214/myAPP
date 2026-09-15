//
//  PowerBankHomeView.m
//  Beillen
//
//  Created by chenyi on 2026/8/29.
//

#import "PowerBankHomeView.h"


@interface PowerBankHomeView()
@property (nonatomic, strong) UIImageView *logImageView ;
@property (nonatomic, strong) UILabel *batteryLab ;
@property (nonatomic, strong) UILabel *timeLab ;

@property (nonatomic, strong) UIView *deviceTempView ;
@property (nonatomic, strong) UIImageView *tempImageView ;
@property (nonatomic, strong) UILabel *tempTextLab ;
@property (nonatomic, strong) UILabel *tempNumLab ;
@end

@implementation PowerBankHomeView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame] ;
    if (self) {
        
    }
    return self;
}

-(void)initAddView {
    
    [self addSubview:self.logImageView];
    [self.logImageView addSubview:self.batteryLab];
    [self addSubview:self.timeLab];
    
    [self addSubview:self.deviceTempView];
    [self.deviceTempView addSubview:self.tempImageView];
    [self.deviceTempView addSubview:self.tempTextLab];
    [self.deviceTempView addSubview:self.tempNumLab];
    
    [self.logImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(192);
        make.width.mas_equalTo(192);
    }];
    [self.batteryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logImageView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(39);
    }];
    
    [self.deviceTempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLab.mas_bottom).offset(0);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(38);
        make.bottom.mas_equalTo(-2);
    }];
    
    [self.tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(17);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(18);
    }];
    [self.tempTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(self.tempImageView.mas_right).offset(16);

    }];
    [self.tempNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(self.tempTextLab.mas_right).offset(16);
        make.right.mas_equalTo(-17);
    }];

    self.batteryLab.attributedText = [self attributeWithNormalValue:@"83%" singleFont:@"%"];
    self.timeLab.text = @"剩余可输出时间：10 H 30 M";
    self.tempTextLab.text = @"设备温度";
    self.tempNumLab.text = @"32.4°C";
    [self addLayerView];
}


-(void)addLayerView {
    CALayer *layer1 = [CALayer new];
    layer1.backgroundColor = bsColorAlphaString(@"#000000", 0.05).CGColor;
    layer1.bounds = self.deviceTempView.bounds;
    layer1.position = self.deviceTempView.center;
    [self.deviceTempView.layer addSublayer:layer1];
    self.deviceTempView.layer.cornerRadius = 19;
    self.deviceTempView.layer.borderWidth = 1;
    self.deviceTempView.layer.borderColor = bsColorAlphaString(@"#C5C4DB", 0.10).CGColor;;
}



-(UIImageView*)logImageView {
    if (!_logImageView) {
        _logImageView = [[UIImageView alloc]init];
        _logImageView.image = [UIImage imageNamed:@"powerBank_home_icon"];
        _logImageView.contentMode = UIViewContentModeScaleAspectFit ;
    }
    return _logImageView;
}

-(UILabel*)batteryLab {
    if (!_batteryLab) {
        _batteryLab = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:48] textAlignment:NSTextAlignmentCenter textColor:[UIColor bs_colorFromARGB:@"#191C1E"]] ;
    }
    return _batteryLab;
}

-(UILabel*)timeLab {
    if (!_timeLab) {
        _timeLab = [UILabel bs_labelWithFont:[UIFont bs_regularFontWithFontSize:12] textAlignment:NSTextAlignmentCenter textColor:[UIColor bs_colorFromARGB:@"#454558"]] ;
    }
    return _timeLab;
}

-(UIView*)deviceTempView{
    if (!_deviceTempView) {
        _deviceTempView = [UIView new];
        _deviceTempView.backgroundColor = [UIColor whiteColor];
    }
    return _deviceTempView;
}

-(UIImageView*)tempImageView {
    if (!_tempImageView) {
        _tempImageView = [[UIImageView alloc]init];
        _tempImageView.image = [UIImage imageNamed:@"powerBank_home_temp"];
        _tempImageView.contentMode = UIViewContentModeScaleAspectFit ;
    }
    return _tempImageView;
}

-(UILabel*)tempTextLab {
    if (!_tempTextLab) {
        _tempTextLab = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:12] textAlignment:NSTextAlignmentCenter textColor:[UIColor bs_colorFromARGB:@"#757589"]] ;
    }
    return _tempTextLab;
}

-(UILabel*)tempNumLab {
    if (!_tempNumLab) {
        _tempNumLab = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:14] textAlignment:NSTextAlignmentCenter textColor:[UIColor bs_colorFromARGB:@"#191C1E"]] ;
    }
    return _tempNumLab;
}

- (NSAttributedString *)attributeWithNormalValue:(NSString *)text singleFont:(NSString *)valsingleFontue
{
    NSString*fullText = text;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullText];
    // 3. 定义两种字体
    UIFont *normalFont = [UIFont bs_semiboldFontWithFontSize:48] ; // 普通文字大小
    UIFont *bigFont = [UIFont bs_semiboldFontWithFontSize:20] ; // 重点文字大小

    // 4. 设置默认字体（可选，先设一个基准）
    [attrString addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, fullText.length)];

    // 5. 单独设置“100”的字体大小
    // 假设 "100" 在字符串中的位置是索引 2，长度为 3
    NSRange range = [fullText rangeOfString:valsingleFontue];
    if (range.location != NSNotFound) {
        [attrString addAttribute:NSFontAttributeName
                           value:bigFont
                           range:range];
        
        // 也可以同时设置颜色，让差异更明显
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor bs_colorFromARGB:@"#191C1E"]
                           range:range];
    }
    return attrString;
}



@end
