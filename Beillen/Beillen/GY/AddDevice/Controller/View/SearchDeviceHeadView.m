//
//  SearchDeviceHeadView.m
//  Beillen
//
//  Created by chenyi on 2026/9/10.
//

#import "SearchDeviceHeadView.h"

@interface SearchDeviceHeadView ()
@property(nonatomic,strong) UIImageView *iconHeadView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *desLab;
@end


@implementation SearchDeviceHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
    }
    return self;
}

- (void)initWithType:(NSInteger)viewType{
    [self addSubview:self.iconHeadView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.desLab];
    [self.iconHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(176);
        make.width.mas_equalTo(176);
        make.centerX.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconHeadView.mas_bottom).offset(24);
        make.height.mas_equalTo(32);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
}

-(UIImageView*)iconHeadView {
    if (!_iconHeadView) {
        _iconHeadView = [[UIImageView alloc]init];
        _iconHeadView.contentMode = UIViewContentModeScaleAspectFit ;
        _iconHeadView.image = [UIImage imageNamed:@"add_search_icon"];
    }
    return _iconHeadView;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = ({
            UILabel *titleLabel  = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:24.0]
                                               textAlignment:NSTextAlignmentCenter
                                                   textColor:[UIColor bs_colorFromARGB:@"#1A1A1A"]];
            titleLabel.text = NSLocalizedStringkey(@"添加设备");
            titleLabel.numberOfLines = 0;
            titleLabel;
        });
    }
    return _titleLabel;
}

- (UILabel *)desLab{
    if(!_desLab){
        _desLab = ({
            UILabel *titleLabel  = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:14.0]
                                               textAlignment:NSTextAlignmentCenter
                                                   textColor:[UIColor bs_colorFromARGB:@"#6B7280"]];
            titleLabel.text = NSLocalizedStringkey(@"扫描中，请将手机尽量靠近设备");
            titleLabel.numberOfLines = 0;
            titleLabel;
        });
    }
    return _desLab;
}

@end
