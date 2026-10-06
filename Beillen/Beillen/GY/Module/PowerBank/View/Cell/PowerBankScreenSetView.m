//
//  PowerBankScreenSetView.m
//  Beillen
//
//  Created by chenyi on 2026/9/30.
//

#import "PowerBankScreenSetView.h"

@interface PowerBankScreenSetCellView()
@property (nonatomic, strong) UIImageView *leftIconView ;
@property (nonatomic, strong) UIButton *iconRightBtn ;
@property (nonatomic, strong) UILabel *typeLab ;
@property (nonatomic, strong) UILabel *messageLab ;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation PowerBankScreenSetCellView
-(void)initAddViewWithType:(NSInteger)typeView {

    [self addSubview:self.leftIconView];
   
    UIView *bgLabview = [UIView new];
    [self addSubview:bgLabview];
    [bgLabview addSubview:self.typeLab];
    [bgLabview addSubview:self.messageLab];
    [self addSubview:self.iconRightBtn];
    [self addSubview:self.selectBtn];
    [self addSubview:self.lineView];
    
    CGFloat sp_left = 24;
    [self.leftIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(0);
    }];
    [self.iconRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-sp_left);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(12);
        make.centerY.mas_equalTo(0);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-sp_left);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(24);
        make.centerY.mas_equalTo(0);
    }];

    [bgLabview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftIconView.mas_right).offset(8);
        make.right.equalTo(self.selectBtn.mas_left).offset(-8);
        make.centerY.mas_equalTo(0);
    }];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLab.mas_bottom).offset(2);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-1);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-sp_left);
        make.left.mas_equalTo(sp_left);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    
    if (typeView == 1) {
        self.iconRightBtn.tag = 1;
        self.typeLab.text = @"计时提醒";
        self.messageLab.text = @"开启后将在计时结束时发出提醒";
        self.leftIconView.image = [UIImage imageNamed:@"pank_screen_set_alarm_icon"];
        self.selectBtn.hidden = YES;
    } else if (typeView ==2) {
        self.selectBtn.tag = 2;
        self.typeLab.text = @"时间显示";
        self.messageLab.text = @"在设备屏幕上显示当前时间";
        self.leftIconView.image = [UIImage imageNamed:@"pank_screen_set_time_icon"];
        self.iconRightBtn.hidden = YES;
    } else if (typeView ==3) {
        self.selectBtn.tag = 3;
        self.typeLab.text = @"成就互动";
        self.messageLab.text = @"在设备屏幕上显示趣味互动表情 味互动表情味互动表情";
        self.leftIconView.image = [UIImage imageNamed:@"pank_screen_set_interact_icon"];
        self.iconRightBtn.hidden = YES;
        self.lineView.hidden = YES;
    }
}

-(UIImageView*)leftIconView {
    if (!_leftIconView) {
        _leftIconView = [[UIImageView alloc]init];
        _leftIconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftIconView;
}

-(UIButton*)iconRightBtn {
    if (!_iconRightBtn) {
        _iconRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconRightBtn setImage:[UIImage imageNamed:@"powerBank_home_right_icon"] forState:UIControlStateNormal];
        _iconRightBtn.bs_touchInset = UIEdgeInsetsMake(-30, -250, -30, -20);
    }
    return _iconRightBtn;
}

-(UILabel*)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:18] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#191C1E"]] ;
    }
    return _typeLab;
}

-(UILabel*)messageLab {
    if (!_messageLab) {
        _messageLab = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:13] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#454558"]] ;
        _messageLab.numberOfLines = 2;
    }
    return _messageLab;
}

-(UIButton*)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"powerBank_home_set_close"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"powerBank_home_set_open"] forState:UIControlStateSelected];
        _selectBtn.bs_touchInset = UIEdgeInsetsMake(-30, -50, -30, -20);
    }
    return _selectBtn;
}

-(UIView*)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor bs_colorFromARGB:@"#C5C4DB" alpha:0.2];
    }
    return _lineView;
}

@end





@interface PowerBankScreenSetTextView()
@property (nonatomic, strong) UIView *bgView ;
@property (nonatomic, strong) UILabel *typeLab ;
@property (nonatomic, strong) UILabel *messageLab ;

@property (nonatomic, strong) UIView *bgBtnView ;
@property (nonatomic, strong) UIButton *whiteBtn ;
@property (nonatomic, strong) UIButton *grayBtn ;
@property (nonatomic, strong) UIView *bgBtnWhiteView ;
@property (nonatomic, strong) UIView *bgBtnGrayView ;
@end

@implementation PowerBankScreenSetTextView
-(void)initAddViewWithType:(NSInteger)typeView {

    CGFloat sp_left = 20;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.typeLab];
    [self.bgView addSubview:self.messageLab];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
        make.top.mas_equalTo(sp_left);
    }];
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
        make.top.equalTo(self.typeLab.mas_bottom).offset(4);
       
    }];

    [self.bgView addSubview:self.bgBtnView];
    [self.bgBtnView addSubview:self.bgBtnWhiteView];
    [self.bgBtnView addSubview:self.bgBtnGrayView];
    [self.bgBtnView addSubview:self.whiteBtn];
    [self.bgBtnView addSubview:self.grayBtn];
    
    [self.bgBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
        make.top.equalTo(self.messageLab.mas_bottom).offset(10);
        make.height.mas_equalTo(64);
        make.bottom.mas_equalTo(-sp_left);
    }];
    
    [self.whiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.right.equalTo(self.bgBtnView.mas_centerX);
    }];
    
    [self.grayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(-8);
        make.left.equalTo(self.bgBtnView.mas_centerX);
    }];
    
    [self.bgBtnWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.self.whiteBtn.mas_width);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.centerX.equalTo(self.whiteBtn.mas_centerX);
    }];
    
    [self.bgBtnGrayView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.self.grayBtn.mas_width);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.centerX.equalTo(self.grayBtn.mas_centerX);
    }];
    
    self.typeLab.text = @"文本颜色";
    self.messageLab.text = @"该选项仅对壁纸页面生效";
    [self upSelectBtnCenterView:typeView];
}

-(void)upSelectBtnCenterView:(NSInteger)type
{
    if (type == 1) {
        self.bgBtnWhiteView.hidden = NO;
        self.bgBtnGrayView.hidden = YES;
    } else if (type == 2) {
        self.bgBtnWhiteView.hidden = YES;
        self.bgBtnGrayView.hidden = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(eventsDidTouched:value:)]) {
        [self.delegate eventsDidTouched:4 value:type];
    }
}

-(void)clickBtn:(UIButton*)button {
    button.selected = !button.selected;
    
    [self upSelectBtnCenterView:button.tag];
    if (button == self.whiteBtn) {
        self.grayBtn.selected = NO;
       
    } else if (button == self.grayBtn) {
        self.whiteBtn.selected = NO;
    }
}

- (UIView *)bgView{
    if (!_bgView) {
        UIView *view = [UIView new];
        view.backgroundColor =[UIColor whiteColor];;
        view.layer.cornerRadius = 32;
        _bgView = view;
    }
    return _bgView;
}

-(UILabel*)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:18] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#191C1E"]] ;
    }
    return _typeLab;
}

-(UILabel*)messageLab {
    if (!_messageLab) {
        _messageLab = [UILabel bs_labelWithFont:[UIFont bs_lightFontWithFontSize:16] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#454558" alpha:0.4]] ;
        _messageLab.numberOfLines = 2;
    }
    return _messageLab;
}

- (UIView *)bgBtnView{
    if (!_bgBtnView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor bs_colorFromARGB:@"#F2F4F6"];
        view.layer.cornerRadius = 32;
        _bgBtnView = view;
    }
    return _bgBtnView;
}

- (UIView *)bgBtnWhiteView{
    if (!_bgBtnWhiteView) {
        UIView *view = [UIView new];
        view.backgroundColor =[UIColor whiteColor];;
        view.layer.cornerRadius = 24;
        view.layer.borderColor = [UIColor bs_colorFromARGB:@"#004098"].CGColor;
        view.layer.borderWidth = 1.5;
        view.hidden = YES;
        _bgBtnWhiteView = view;
    }
    return _bgBtnWhiteView;
}

- (UIView *)bgBtnGrayView{
    if (!_bgBtnGrayView) {
        UIView *view = [UIView new];
        view.backgroundColor =[UIColor whiteColor];;
        view.layer.cornerRadius = 24;
        view.layer.borderColor = [UIColor bs_colorFromARGB:@"#004098"].CGColor;
        view.layer.borderWidth = 1.5;
        view.hidden = YES;
        _bgBtnGrayView = view;
    }
    return _bgBtnGrayView;
}
    
-(UIButton*)whiteBtn {
    if (!_whiteBtn) {
        _whiteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_whiteBtn setTitle:@"白色" forState:UIControlStateNormal];
        _whiteBtn.tag = 1;
        [_whiteBtn setTitleColor:[UIColor bs_colorFromARGB:@"#454558"] forState:UIControlStateNormal];
        [_whiteBtn setTitleColor:[UIColor bs_colorFromARGB:@"#191C1E"] forState:UIControlStateSelected];
        [_whiteBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _whiteBtn;
}

-(UIButton*)grayBtn{
    if (!_grayBtn) {
        _grayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_grayBtn setTitleColor:[UIColor bs_colorFromARGB:@"#454558"] forState:UIControlStateNormal];
        [_grayBtn setTitleColor:[UIColor bs_colorFromARGB:@"#191C1E"] forState:UIControlStateSelected];
        [_grayBtn setTitle:@"深灰色" forState:UIControlStateNormal];
        _grayBtn.tag = 2;
        [_grayBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _grayBtn;
}

@end





@interface PowerBankScreenSetView()
@property (nonatomic, strong) UIImageView *bgIconView ;
@property (nonatomic, strong) UIView *bgView ;
@property (nonatomic, strong) PowerBankScreenSetCellView *alarmView ;
@property (nonatomic, strong) PowerBankScreenSetCellView *timeView ;
@property (nonatomic, strong) PowerBankScreenSetCellView *interactView ;

@end
@implementation PowerBankScreenSetView

-(void)initAddViewWithType:(NSInteger)typeView {
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.bgIconView];
    [self.bgView addSubview:self.alarmView];
    [self.bgView addSubview:self.timeView];
    [self.bgView addSubview:self.interactView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    [self.bgIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.alarmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(87);
        make.top.mas_equalTo(0);
    }];
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alarmView.mas_bottom).offset(0);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(87);
    }];
    [self.interactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_bottom).offset(0);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(87);
        make.bottom.mas_equalTo(0);
    }];
}

-(void)clickWitchBtn:(UIButton*)button{
    NSInteger tag = button.tag ;
    NSLog(@"tag === %ld",tag);
    
    if (tag == 2 || tag == 3) {
        button.selected = !button.selected;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(eventsDidTouched:value:)]) {
        [self.delegate eventsDidTouched:tag value:button.selected];
    }
}

-(UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}

-(UIImageView*)bgIconView {
    if (!_bgIconView) {
        _bgIconView = [[UIImageView alloc]init];
        _bgIconView.image = [UIImage imageNamed:@"pank_modelView_cell_bg"];
    }
    return _bgIconView;
}

-(PowerBankScreenSetCellView*)alarmView {
    if (!_alarmView) {
        _alarmView = [PowerBankScreenSetCellView new];
        [_alarmView initAddViewWithType:1];
        [_alarmView.iconRightBtn addTarget:self action:@selector(clickWitchBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alarmView;
}

-(PowerBankScreenSetCellView*)timeView {
    if (!_timeView) {
        _timeView = [PowerBankScreenSetCellView new];
        [_timeView initAddViewWithType:2];
        [_timeView.selectBtn addTarget:self action:@selector(clickWitchBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeView;
}

-(PowerBankScreenSetCellView*)interactView {
    if (!_interactView) {
        _interactView = [PowerBankScreenSetCellView new];
        [_interactView initAddViewWithType:3];
        [_interactView.selectBtn addTarget:self action:@selector(clickWitchBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _interactView;
}

@end
