//
//  PowerBankTypeView.m
//  Beillen
//
//  Created by chenyi on 2026/8/30.
//

#import "PowerBankTypeView.h"

@interface PowerBankTypeView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *bgLabView;
@property (nonatomic, strong) UILabel *typeLab ;
@property (nonatomic, strong) UILabel *typeStateLab ;
@property (nonatomic, strong) UILabel *laber_W ;
@property (nonatomic, strong) UILabel *typeDeviceName ;
@property (nonatomic, strong) UILabel *laber_V_A ;

@end


@implementation PowerBankTypeView

-(void)initAddView {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.bgLabView];
    [self.bgLabView addSubview:self.typeLab];
    
    [self.bgView addSubview:self.typeStateLab];
    [self.bgView addSubview:self.laber_W];
    [self.bgView addSubview:self.laber_V_A];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.bgLabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(40);
    }];
    
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    [self.typeStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.left.equalTo(self.bgLabView.mas_right).offset(10);
        make.centerY.equalTo(self.bgLabView.mas_centerY).offset(0);
    }];
    
    [self.laber_W mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.bgLabView.mas_bottom).offset(11);
        make.height.mas_equalTo(24);
    }];
    
    [self.laber_V_A mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.laber_W.mas_bottom).offset(4);
        make.height.mas_equalTo(15);
    }];
    [self addLayerView];
}

-(void)addLayerView {
    CALayer *layer1 = [CALayer new];
    layer1.backgroundColor = bsColorAlphaString(@"#000000", 0.03).CGColor;
    layer1.bounds = self.bgView.bounds;
    layer1.position = self.bgView.center;
    [self.bgView.layer addSublayer:layer1];
    self.bgView.layer.cornerRadius = 32;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = bsColorAlphaString(@"#C5C4DB", 0.05).CGColor;
    self.bgLabView.layer.cornerRadius = 10;
}

-(void)upTypeModel:(BSCommonDeviceTypeModel *)typeModel isConnet:(BOOL)isConnet{
    _typeModel = typeModel;
    self.typeLab.text = typeModel.typeName;
    NSString *typeStateStr = @"--";
    NSString *typeW = @"--W";
    NSString *typeVA = @"--V / --A";
    NSInteger typeConnect = typeModel.typeConnect;
    if (isConnet) {
        if (typeConnect) {
            if (typeModel.typeState) {
                typeStateStr = @"输入";
            } else {
                typeStateStr = @"输出";
            }
            typeW = [NSString stringWithFormat:@"%.1fW",(CGFloat)(typeModel.typeModelW.typeValue) ];
            typeVA = [NSString stringWithFormat:@"%.1fV / %.2fA",(CGFloat)(typeModel.typeModelV.typeValue/1000.0),(CGFloat)(typeModel.typeModelA.typeValue/1000.0) ];
        }
    }
    self.typeStateLab.text = typeStateStr;
    self.laber_V_A.text = typeVA;
    self.laber_W.attributedText = [self attributeWithNormalValue:typeW singleFont:@"W"];
}

- (NSAttributedString *)attributeWithNormalValue:(NSString *)text singleFont:(NSString *)valsingleFontue
{
    NSString*fullText = text;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullText];
    // 3. 定义两种字体
    UIFont *normalFont = [UIFont bs_semiboldFontWithFontSize:24] ; // 普通文字大小
    UIFont *bigFont = [UIFont bs_semiboldFontWithFontSize:14] ; // 重点文字大小

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

-(UIView*)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

-(UIView*)bgLabView{
    if (!_bgLabView) {
        _bgLabView = [UIView new];
        _bgLabView.backgroundColor = [UIColor bs_colorFromARGB:@"#454545" alpha:0.1];
    }
    return _bgLabView;
}

-(UILabel*)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel bs_labelWithFont:[UIFont bs_PingFangBoldFontWithFontSize:14] textAlignment:NSTextAlignmentCenter textColor:[UIColor bs_colorFromARGB:@"#004098"]] ;
    }
    return _typeLab;
}

-(UILabel*)typeStateLab {
    if (!_typeStateLab) {
        _typeStateLab = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:14] textAlignment:NSTextAlignmentRight textColor:[UIColor bs_colorFromARGB:@"#004098"]] ;
    }
    return _typeStateLab;
}

-(UILabel*)laber_W {
    if (!_laber_W) {
        _laber_W = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:24] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#191C1E"]] ;
    }
    return _laber_W;
}

-(UILabel*)typeDeviceName {
    if (!_typeDeviceName) {
        _typeDeviceName = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:12] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#454558"]] ;
    }
    return _typeDeviceName;
}

-(UILabel*)laber_V_A {
    if (!_laber_V_A) {
        _laber_V_A = [UILabel bs_labelWithFont:[UIFont bs_regularFontWithFontSize:14] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#9D9D9D"]] ;
    }
    return _laber_V_A;
}

@end
