//
//  PowerBankModelCellView.m
//  Beillen
//
//  Created by chenyi on 2026/9/30.
//

#import "PowerBankModelCellView.h"
@interface PowerBankModelCellView()
@property (nonatomic, strong) UIImageView *imageBgView ;
@property (nonatomic, strong) UIImageView *iconView ;
@property (nonatomic, strong) UILabel *typeLab ;
@property (nonatomic, strong) UILabel *messageLab ;
@property (nonatomic, strong) UILabel *titleLab1 ;
@property (nonatomic, strong) UILabel *titleLab2 ;
@end

@implementation PowerBankModelCellView

-(void)initAddViewWithType:(NSInteger)typeView{
    
    CGFloat sp_left = 28;
    if (typeView == 1) {
        self.selectBtn.tag = 0;
        self.iconView.image = [UIImage imageNamed:@"pank_modelView_cell_icon_1"];
        self.typeLab.text = @"智能模式";
        self.messageLab.text = @"自动识别设备并匹配快充协议，提供更快的充电速度，最高支持 310W，适合需要快速补电的场景。";
        self.titleLab1.text = @"极速闪充";
        self.titleLab2.text = @"智慧温控";
    } else if (typeView == 2) {
        self.selectBtn.tag = 1;
        self.iconView.image = [UIImage imageNamed:@"pank_modelView_cell_icon_2"];
        self.typeLab.text = @"长寿模式";
        self.messageLab.text =  @"定的标准充电模式，适合日常使用，在保证正常充电的同时更好保护电池寿命。";
        self.titleLab1.text = @"健康管理";
        self.titleLab2.text = @"夜间守护";
    } else if (typeView == 3) {
        self.selectBtn.tag = 2;
        self.iconView.image = [UIImage imageNamed:@"pank_modelView_cell_icon_3"];
        self.typeLab.text = @"自定义模式";
        self.messageLab.text = @"由用户自行设定充电功率、截止电量及保护策略，适合进阶发烧友使用。";
        self.titleLab1.text = @"参数调节";
        self.titleLab2.hidden = YES;
    }
    [self addSubview:self.imageBgView];
    [self addSubview:self.iconView];
    [self addSubview:self.typeLab];
    [self addSubview:self.messageLab];
    [self addSubview:self.titleLab1];
    [self addSubview:self.titleLab2];
    [self addSubview:self.selectBtn];
    [self.imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.top.mas_equalTo(sp_left);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.mas_centerY).offset(0);
        make.left.equalTo(self.iconView.mas_right).offset(16);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.mas_centerY).offset(0);
        make.right.mas_equalTo(-sp_left);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];

    [self.titleLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(24);
        make.bottom.mas_equalTo(-sp_left);
    }];

    [self.titleLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab1.mas_right).offset(8);
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(24);
        make.bottom.mas_equalTo(-sp_left);
    }];

    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(20);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
    }];
}

-(UIImageView*)imageBgView {
    if (!_imageBgView) {
        _imageBgView = [[UIImageView alloc]init];
        _imageBgView.contentMode = UIViewContentModeScaleToFill;
        [_imageBgView setImage:[UIImage imageNamed:@"pank_modelView_cell_bg"]];
    }
    return _imageBgView;
}

-(UIImageView*)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

-(UILabel*)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:24] textAlignment:NSTextAlignmentRight textColor:[UIColor bs_colorFromARGB:@"#191C1E"]] ;
    }
    return _typeLab;
}

-(UILabel*)messageLab {
    if (!_messageLab) {
        _messageLab = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:16] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#454558"]] ;
        _messageLab.numberOfLines = 0;
    }
    return _messageLab;
}

-(UILabel*)titleLab1 {
    if (!_titleLab1) {
        _titleLab1 = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:12] textAlignment:NSTextAlignmentCenter textColor:[UIColor bs_colorFromARGB:@"#404040"]] ;
        _titleLab1.backgroundColor = [UIColor bs_colorFromARGB:@"#131313" alpha:0.05];
        _titleLab1.layer.cornerRadius = 12.0;
        _titleLab1.layer.masksToBounds = YES;
    }
    return _titleLab1;
}

-(UILabel*)titleLab2 {
    if (!_titleLab2) {
        _titleLab2 = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:12] textAlignment:NSTextAlignmentCenter textColor:[UIColor bs_colorFromARGB:@"#404040"]] ;
        _titleLab2.backgroundColor = [UIColor bs_colorFromARGB:@"#131313" alpha:0.05];
        _titleLab2.layer.cornerRadius = 12.0;
        _titleLab2.layer.masksToBounds = YES;
    }
    return _titleLab2;
}

-(UIButton*)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"pank_modelView_cell_btn_d"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"pank_modelView_cell_btn_s"] forState:UIControlStateSelected];
        _selectBtn.bs_touchInset = UIEdgeInsetsMake(-20, -250, -180, -50);
    }
    return _selectBtn;
}

@end
