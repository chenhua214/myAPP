//
//  BSMineListCell.m
//  Beillen
//
//  Created by  wang on 2021/1/19.
//

#import "BSMineListCell.h"
@interface BSMineListCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *rightIcon;
@end

@implementation BSMineListCell

#pragma mark- Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

#pragma mark- setup

- (void)setup{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = self.contentView.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [self setupConstraints];
}

- (void)createUI{
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.icon];
    [self.containerView addSubview:self.titleLab];
    [self.containerView addSubview:self.rightIcon];
}

- (void)setupConstraints{
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.right.equalTo(self.bgView);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self.containerView.mas_centerY);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(56);
        make.right.mas_equalTo(-41);
        make.centerY.equalTo(self.icon.mas_centerY);
    }];
    
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.containerView.mas_centerY);
    }];
}

#pragma mark- Public methods

- (void)setIconNamed:(NSString *)imageName title:(NSString *)title corner:(BSCellRectCorner)corner{
    [self setIconNamed:imageName title:title corner:corner disabled:NO top:0 bottom:0];
}

- (void)setIconNamed:(NSString *)imageName title:(NSString *)title corner:(BSCellRectCorner)corner disabled:(BOOL)disabled top:(CGFloat)top bottom:(CGFloat)bottom{
    self.icon.image = [UIImage imageNamed:imageName];
    self.titleLab.text = title;
    self.icon.alpha = self.titleLab.alpha = self.rightIcon.alpha = disabled ? 0.5 : 1;
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.bottom.mas_equalTo(bottom);
    }];
}

#pragma mark- Setters && Getters

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = [UIColor bs_colorFromARGB:@"#333333"];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = [UIFont bs_mediumFontWithFontSize:16.0];
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc]init];
        _rightIcon.image = [UIImage imageNamed:@"mine_list_right"];
    }
    return _rightIcon;
}

@end
