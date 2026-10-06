//
//  PowerBankTimeSetCellView.m
//  Beillen
//
//  Created by chenyi on 2026/10/6.
//

#import "PowerBankTimeSetCellView.h"
@interface PowerBankTimeSetCellView()
@property (nonatomic, strong) UIView *bgView ;
@property (nonatomic, strong) UILabel *typeLab ;
@property (nonatomic, strong) UIImageView *iconView ;
@property (nonatomic, strong) UIView *lineView ;
@property (nonatomic, assign) NSInteger typeView ;
@property (nonatomic, assign) NSInteger timeNumber ;
@end
@implementation PowerBankTimeSetCellView

-(void)initAddViewWithType:(NSInteger)typeView time:(NSInteger)timeNumber timeType:(NSString *)tiemeTypeStr {
    
    _typeView = typeView;
    _timeNumber = timeNumber;
    [self addSubview:self.bgView];
    [self addSubview:self.lineView];
    [self.bgView addSubview:self.typeLab];
    [self.bgView addSubview:self.iconView];
    [self.bgView addSubview:self.selectBtn];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(18);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    self.typeLab.attributedText = [self attributeWithNormalValue:timeNumber singleFont:tiemeTypeStr];
    self.selectBtn.tag = typeView;
}

-(void)selectForView:(BOOL)isSelect{
    if (isSelect) {
        self.lineView.layer.hidden = NO;
        self.iconView.layer.hidden = NO;
    }  else {
        self.lineView.layer.hidden = YES;
        self.iconView.layer.hidden = YES;
    }
}

- (NSAttributedString *)attributeWithNormalValue:(NSInteger )text singleFont:(NSString *)valsingleFontue
{
    NSString*fullText = [NSString stringWithFormat:@"%ld%@",text,valsingleFontue];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullText];
    // 3. 定义两种字体
    UIFont *normalFont = [UIFont bs_semiboldFontWithFontSize:44] ; // 普通文字大小
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
    }
    return attrString;
}

-(void)clickSeletBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(eventsDidTouchedForView:Type:value:)]) {
        [self.delegate eventsDidTouchedForView:self Type:self.typeView value:self.timeNumber];
    }
    [self selectForView:YES];
}

- (UIView *)bgView{
    if (!_bgView) {
        UIView *view = [UIView new];
        view.backgroundColor =[UIColor whiteColor];;
        view.layer.cornerRadius = 24;
        _bgView = view;
    }
    return _bgView;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView *view = [UIView new];
        view.layer.cornerRadius = 24;
        view.layer.borderColor = [UIColor bs_colorFromARGB:@"#004098"].CGColor;
        view.layer.borderWidth = 2;
        view.hidden = YES;
        _lineView = view;
    }
    return _lineView;
}

-(UIImageView*)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [_iconView setImage:[UIImage imageNamed:@"pank_modelView_cell_btn_s"]];
        _iconView.hidden = YES;
    }
    return _iconView;
}

-(UILabel*)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:44] textAlignment:NSTextAlignmentCenter textColor:[UIColor bs_colorFromARGB:@"#004098"]] ;
    }
    return _typeLab;
}

-(UIButton*)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn addTarget:self action:@selector(clickSeletBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

@end
