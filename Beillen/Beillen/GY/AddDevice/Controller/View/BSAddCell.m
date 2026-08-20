//
//  BSAddCell.m
//  Beillen
//
//  Created by baseus_ouyang on 2021/2/4.
//

#import "BSAddCell.h"

@interface BSAddCell ()
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIImageView *iconView;
@property(nonatomic,strong) UIButton *stateBtn;
@property(nonatomic,strong) UIStackView *stackView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *macLabel;

@property(nonatomic,strong) BSDeviceBLE *model;
@property(nonatomic,  copy) NSString *iconURL;

@end

@implementation BSAddCell

#pragma mark- Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark- setup

- (void)setup{
    self.backgroundColor = self.contentView.backgroundColor = [UIColor bs_colorFromARGB:@"#F8F8F8"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self createUI];
    [self setupConstraints];
}

- (void)createUI{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconView];
    [self.bgView addSubview:self.stackView];
    [self.bgView addSubview:self.stateBtn];
}

- (void)setupConstraints{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 10, 10));
    }];

    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.width.height.mas_equalTo(60);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(16);
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.right.equalTo(self.stateBtn.mas_left).offset(-16);
    }];

    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
}

#pragma mark- Public methods

- (void)setIconURL:(NSString *)iconURL name:(NSString *)name mac:(NSString *)mac checked:(BOOL)checked{
    [self setIconURL:iconURL name:name mac:mac checked:checked backgroundColorHexString:nil];
}

- (void)setIconURL:(NSString *)iconURL name:(NSString *)name mac:(NSString *)mac checked:(BOOL)checked backgroundColorHexString:(NSString *)backgroundColorHexString{
    if (iconURL.isEnable) {
//        [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"device_placeholder_icon"]];
    }else{
        self.iconView.image = [UIImage imageNamed:@"device_placeholder_icon"];
    }
    self.nameLabel.text = (name && name.length > 0) ? name : @"";
    BOOL macEnabled = mac.isEnable;
    self.macLabel.text = macEnabled ? [NSString stringWithFormat:@"%@:%@",NSLocalizedStringkey(@"mac_address"),mac] : @"";
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.mas_centerY).offset(macEnabled ? -12 : 0);
    }];
    self.stateBtn.selected = checked;
    if(backgroundColorHexString){
        self.backgroundColor = self.contentView.backgroundColor = self.bgView.backgroundColor = [UIColor bs_colorFromARGB:backgroundColorHexString];
    }else{
        self.backgroundColor = self.contentView.backgroundColor = self.bgView.backgroundColor = [UIColor bs_colorFromARGB:@"#F8F8F8"];
    }
}

#pragma mark- Setters && Getters

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor bs_colorFromARGB:@"#F2F4F8"];
    }
    return _bgView;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.image = [UIImage imageNamed:@"device_placeholder_icon"];
    }
    return _iconView;
}

- (UIStackView *)stackView{
    if (!_stackView) {
        _stackView = [UIStackView new];
        [_stackView addArrangedSubview:self.nameLabel];
        [_stackView addArrangedSubview:self.macLabel];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.spacing = 8.0;
    }
    return _stackView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:16]
                                 textAlignment:NSTextAlignmentLeft
                                     textColor:[UIColor bs_colorFromARGB:@"#333333"]
                                       bgColor:nil];
    }
    return _nameLabel;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [UILabel bs_labelWithFont:[UIFont bs_regularFontWithFontSize:12]
                                textAlignment:NSTextAlignmentLeft
                                    textColor:[UIColor bs_colorFromARGB:@"#999999"]
                                      bgColor:nil];
    }
    return _macLabel;
}

- (UIButton *)stateBtn{
    if (!_stateBtn) {
        _stateBtn = ({
            UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"black_uncheck"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"black_checked"] forState:UIControlStateSelected];
            button.userInteractionEnabled = NO;
            button;
        });
    }
    return _stateBtn;
}

@end
