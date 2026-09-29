//
//  BSHomePageHeader.m
//  Beillen
//
//  Created by chenyi on 2026/9/26.
//

#import "BSHomePageHeader.h"

@interface BSHomePageHeader()
/// 去添加设备
@property (nonatomic, strong) UIButton *goAddBtn;
@property (nonatomic, strong) UIImageView *logImg;
/// 用户昵称
@property (nonatomic, strong) UILabel *nickNameLab;
@end


@implementation BSHomePageHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
    }
    return self;
}

#pragma mark - UI

- (void)initSubview
{
    [self addSubview:self.logImg];
    [self addSubview:self.nickNameLab];
    [self addSubview:self.goAddBtn];
    CGFloat sp_left = 24;
    
    [self.goAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-sp_left);
        make.bottom.mas_equalTo(-sp_left);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.logImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.goAddBtn);
    }];

    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logImg.mas_right).offset(8);
        make.centerY.equalTo(self.logImg);
    }];
}

/// 切换语言、更新内容
- (void)updateOnChangeLanguages
{

}

- (void)eventDidTouched:(UIButton *)sender
{
    BSHomePageEventsType events = BSHomePageEventsTypeAddDevice;
    if (self.delegate && [self.delegate respondsToSelector:@selector(homePageHeaderEventsWithType:)]) {
        [self.delegate homePageHeaderEventsWithType:events];
    }
}

- (UIImageView *)logImg {
    if (!_logImg) {
        _logImg = [UIImageView new];
        _logImg.image = [UIImage imageNamed:@"home_device_elect"];
        _logImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logImg;
}

- (UILabel *)nickNameLab {
    if (!_nickNameLab) {
        _nickNameLab = [UILabel new];
        _nickNameLab.font = bsFontBold(20);
        _nickNameLab.textColor = bsColorString(@"#004098");
        _nickNameLab.text = NSLocalizedStringkey(@"Beillen");
    }
    return _nickNameLab;
}

- (UIButton *)goAddBtn {
    if (!_goAddBtn) {
        _goAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goAddBtn setImage:[UIImage imageNamed:@"home_add_devices"] forState:UIControlStateNormal];
        [_goAddBtn addTarget:self action:@selector(eventDidTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goAddBtn;
}

@end
