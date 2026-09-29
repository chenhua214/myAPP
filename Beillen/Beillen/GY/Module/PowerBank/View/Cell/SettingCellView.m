//
//  SettingCellView.m
//  Beillen
//
//  Created by chenyi on 2026/9/23.
//

#import "SettingCellView.h"
@interface SettingCellView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *iconView ;
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSString *messageStr;
@property (nonatomic, strong) NSString *iconStr;
@property (nonatomic, assign) NSInteger typeView;
@property (nonatomic, assign) BOOL isLineShow;
@end
@implementation SettingCellView

-(void)initAddView{
    
}

-(void)initAddViewWithType:(NSInteger)typeView
                      type:(NSString*)type
                   message:(NSString*)message
                      icon:(NSString*)icon
                  showLine:(BOOL)hidden{
    _typeStr     = type;
    _typeView    = typeView;
    _messageStr  = message;
    _iconStr     = icon;
    _isLineShow = hidden;
  
    if (typeView == 1) {
        [self initTypeViewForRightBtn];
    } else if (typeView == 2) {
        [self initTypeViewForIcon];
    } else if (typeView == 3) {
        [self initTypeViewForMessage];
    } else if (typeView == 4) {
        [self initTypeViewForIconBtn];
    } else if (typeView == 5) {
        [self initTypeViewForLanguage];
    }
}

// 1
-(void)initTypeViewForRightBtn {
    CGFloat sp_left = 20;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.typeLab];
    [self.bgView addSubview:self.messageLab];
    [self.bgView addSubview:self.rightBtn];
    self.rightBtn.hidden = NO ;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-sp_left);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(12);
    }];
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-45);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
  
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.right.equalTo(self.messageLab.mas_left).offset(-8);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.typeLab.text = self.typeStr;
    self.messageLab.text = self.messageStr;
}

// 2
-(void)initTypeViewForIcon {
    CGFloat sp_left = 20;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.typeLab];
    [self.bgView addSubview:self.messageLab];
    [self.bgView addSubview:self.rightBtn];
    self.rightBtn.hidden = NO ;
    if (self.iconStr.isEnable) {
        [self.rightBtn setImage:[UIImage imageNamed:self.iconStr] forState:UIControlStateNormal];
    }
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-sp_left);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
  
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.right.equalTo(self.messageLab.mas_left).offset(-8);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.typeLab.text = self.typeStr;
    self.messageLab.text = self.messageStr;
}

// 3
-(void)initTypeViewForMessage {
    CGFloat sp_left = 20;
    [self addSubview:self.typeLab];
    [self addSubview:self.messageLab];
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-sp_left);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
  
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.right.equalTo(self.messageLab.mas_left).offset(-8);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    if (_isLineShow) {
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sp_left);
            make.right.mas_equalTo(-sp_left);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
    }
    self.typeLab.text = self.typeStr;
    self.messageLab.text = self.messageStr;
}

// 4
-(void)initTypeViewForIconBtn {
    
    CGFloat sp_left = 20;
    [self addSubview:self.iconView];
    [self addSubview:self.typeLab];
    [self addSubview:self.messageLab];
    [self addSubview:self.rightBtn];
    self.rightBtn.hidden = NO ;
    if (self.iconStr.isEnable) {
        self.iconView.image = [UIImage imageNamed:self.iconStr];
    }
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-sp_left);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
  
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(76);
        make.right.equalTo(self.messageLab.mas_left).offset(-8);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    if (_isLineShow) {
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sp_left);
            make.right.mas_equalTo(-sp_left);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
    }
    self.typeLab.text = self.typeStr;
    self.messageLab.text = self.messageStr;
}

// 5
-(void)initTypeViewForLanguage{
    CGFloat sp_left = 60;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.iconSpotView];
    [self.bgView addSubview:self.typeLab];
    [self.bgView addSubview:self.messageLab];
    [self.bgView addSubview:self.rightBtn];
    self.rightBtn.hidden = NO ;
    [self.rightBtn setImage:[UIImage imageNamed:@"my_Language_Normal"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"my_Language_select"] forState:UIControlStateSelected];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.iconSpotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-60);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
  
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.right.equalTo(self.messageLab.mas_left).offset(-8);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.typeLab.text = self.typeStr;
    self.messageLab.text = self.messageStr;
}

-(void)clickSwith:(UIButton*)button {
    NSLog(@"点击按钮");
}

-(UIView*)bgView{
    if (!_bgView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor bs_colorFromARGB:@"#FFFFFF"];
        view.layer.cornerRadius = 30;
        _bgView = view;
    }
    return _bgView;
}

-(UIView*)iconSpotView{
    if (!_iconSpotView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor bs_colorFromARGB:@"#191C1E"];
        view.layer.cornerRadius = 4;
        view.hidden = YES;
        _iconSpotView = view;
    }
    return _iconSpotView;
}

-(UIView*)lineView{
    if (!_lineView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor bs_colorFromARGB:@"#C5C4DB" alpha:0.1];
        _lineView = view;
    }
    return _lineView;
}

-(UILabel*)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:16] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#191C1E"]] ;
    }
    return _typeLab;
}

-(UILabel*)messageLab {
    if (!_messageLab) {
        _messageLab = [UILabel bs_labelWithFont:[UIFont bs_lightFontWithFontSize:16] textAlignment:NSTextAlignmentRight textColor:[UIColor bs_colorFromARGB:@"#454558"]] ;
    }
    return _messageLab;
}

-(UIImageView*)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

-(UIButton*)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"powerBank_home_right_icon"] forState:UIControlStateNormal];
        _rightBtn.bs_touchInset = UIEdgeInsetsMake(-20, -150, -20, -50);
        _rightBtn.hidden = YES ;
    }
    return _rightBtn;
}

@end
