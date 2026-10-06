//
//  SegmentedView.m
//  Beillen
//
//  Created by chenyi on 2026/9/17.
//

#import "SegmentedView.h"
#import "PowerBankScreenSetViewController.h"

#pragma mark   线材Type选择view   ============
@interface selectTypeView()
@property (nonatomic, strong) UIView *bgView ;
@property (nonatomic, strong) UISegmentedControl *seg;
@property (nonatomic, strong) UIView *selectBgView ;
@property (nonatomic, assign) CGFloat itemNumber;
@property (nonatomic,strong) BSPowerBankDevice *deviceModel;
@property (nonatomic, copy  ) void (^dataDidChangedBlock)(NSInteger selectIndex);
@end
@implementation selectTypeView
-(void)initAddView{
    [self addSubview: self.bgView];
    [self.bgView addSubview:self.selectBgView];
    [self.bgView addSubview:self.seg];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    CGFloat width =  self.width>0 ? self.width:(kScreenWidth-48*2);
    width = (width-15)/3.0;
    [self.selectBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.width.mas_equalTo(width);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
}


-(void)updataForSetting {
    CGFloat width =  self.width>0 ? self.width:(kScreenWidth-48*2);
    self.itemWidth = width/self.itemNumber;
    width = self.itemWidth - 12;
    CGFloat centerx = -self.itemWidth *self.itemNumber /2.0;
    self.seg.selectedSegmentIndex = 0;
    [self.selectBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.centerX.mas_equalTo(centerx + self.itemWidth * 0.5);
    }];
    
    self.selectBgView.layer.cornerRadius = 15.5;
    self.bgView.layer.cornerRadius = 21;
}


-(void)setArrItems:(NSArray *)arrItems {
    _arrItems = arrItems;
    NSInteger number = arrItems.count;
    number = number==0 ? 1 : number;
    self.itemNumber = number;
    [self.seg removeAllSegments];
    for (NSInteger i=0; i<arrItems.count; i++) {
        NSString *text = arrItems[i];
        [self.seg insertSegmentWithTitle:text atIndex:i animated:NO];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updataForSetting];
    });
}

// 实现点击回调方法
- (void)segDidClick:(UISegmentedControl *)sender {
    NSInteger currentIndex = sender.selectedSegmentIndex;

    self.selectedIndex = currentIndex;
    CGFloat widht = -self.itemWidth *self.itemNumber /2.0;
    [self.selectBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(widht + self.itemWidth * (currentIndex + 0.5));
    }];
    NSLog(@"点击事件： %ld",currentIndex);
    if(self.dataDidChangedBlock){
        self.dataDidChangedBlock(currentIndex);
    }
}

-(void)updateForView {
    if (self.selectedIndex == 0) {
        
    }
}

-(UIView*)bgView{
    if (!_bgView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor bs_colorFromARGB:@"#ECEEF0"];
        _bgView = view;
    }
    return _bgView;
}

-(UIView*)selectBgView{
    if (!_selectBgView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor bs_colorFromARGB:@"#FFFFFF"];
        _selectBgView = view;
    }
    return _selectBgView;
}

-(UISegmentedControl*)seg{
    if (!_seg) {
        UISegmentedControl *seg =[UISegmentedControl new];
        // 覆盖所有状态的背景图和分隔线
        [seg setBackgroundImage:[self getClearImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [seg setBackgroundImage:[self getClearImage] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [seg setDividerImage:[self getClearImage] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        // 配置普通未选中态文字样式
        [seg setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor bs_colorFromARGB:@"#454558"],
            NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]
        } forState:UIControlStateNormal];

        // 配置选中态文字样式
        [seg setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor bs_colorFromARGB:@"#004098"],
            NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]
        } forState:UIControlStateSelected];
        [seg addTarget:self action:@selector(segDidClick:) forControlEvents:UIControlEventValueChanged];
        _seg = seg;
    }
    return _seg;
}

// 生成1x1像素的透明图片
- (UIImage *)getClearImage {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    UIImage *clearImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return clearImg;
}
@end
#pragma mark   线材Type选择view   ========== end




#pragma mark   线材信息   view    ==========

@interface SelectTypeMessageView()
@property (nonatomic, strong) UIImageView *iconView ;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *messageLab ;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation SelectTypeMessageView

-(void)initAddView{
    [self addSubview: self.iconView];
    [self addSubview:self.typeLab];
    [self addSubview:self.messageLab];
    [self addSubview:self.lineView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(3);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(8);
        make.right.equalTo(self.messageLab.mas_left).offset(-8);
        make.centerY.mas_equalTo(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

-(void)upMessageWithText:(NSString*)text {
    self.messageLab.text = text;
}

-(void)initMessageWithType:(NSString*)type icon:(NSString*)icon line:(BOOL)line {
    self.typeLab.text = type;
    self.messageLab.text = @"--";
    self.iconView.image = [UIImage imageNamed:icon];
    self.lineView.hidden = !line;
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
        _typeLab = [UILabel bs_labelWithFont:[UIFont bs_regularFontWithFontSize:14] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#757589"]] ;
    }
    return _typeLab;
}

-(UILabel*)messageLab {
    if (!_messageLab) {
        _messageLab = [UILabel bs_labelWithFont:[UIFont bs_lightFontWithFontSize:14] textAlignment:NSTextAlignmentRight textColor:[UIColor bs_colorFromARGB:@"#191C1E"]] ;
    }
    return _messageLab;
}

-(UIView*)lineView{
    if (!_lineView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor bs_colorFromARGB:@"#C5C4DB" alpha:0.1];
        _lineView = view;
    }
    return _lineView;
}
@end




#pragma mark   线材信息   view
@interface TypeMessageView()
@property (nonatomic, strong) SelectTypeMessageView *messageView ;
@property (nonatomic, strong) SelectTypeMessageView *protocolView ;
@property (nonatomic, strong) SelectTypeMessageView *deviceTypeView ;

@end

@implementation TypeMessageView

-(void)initAddView{
    [self addSubview: self.messageView];
    [self addSubview:self.protocolView];
    [self addSubview:self.deviceTypeView];
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageView.mas_bottom).offset(12);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    [self.deviceTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.protocolView.mas_bottom).offset(12);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
        make.bottom.mas_equalTo(0);
    }];
    [self.messageView initMessageWithType:@"线材信息" icon:@"powerBank_type_lineMessage" line:YES];
    [self.protocolView initMessageWithType:@"充电协议" icon:@"powerBank_type_protocol" line:YES];
    [self.deviceTypeView initMessageWithType:@"设备型号" icon:@"powerBank_type_model" line:NO];
}

-(void)updataForViewWithModel:(BSCommonDeviceTypeModel*)model isConnected:(BOOL)isConnected {
    if (isConnected == NO || model.typeConnect == 0) {
        self.messageView.messageLab.text = @"--";
        self.protocolView.messageLab.text = @"--";
        self.deviceTypeView.messageLab.text = @"--";
        return;
    }
    self.messageView.messageLab.text = [[NSString alloc] initWithFormat:@"%ldA-%ldW",model.typeCMessageMaxA,model.typeCMessageMaxW];
    self.protocolView.messageLab.text = [self updataWihtTypeCType:model.typeCType];
    self.deviceTypeView.messageLab.text = model.typeCTypeMessageDeviceName;
}

-(NSString*)updataWihtTypeCType:(BSPowerBankTypecType)typeCType {
    NSString *typeStr = @"--";
    switch (typeCType) {
        case BSPowerBankTypecType_IDLE:
            typeStr = @"IDLE";
            break;
        case BSPowerBankTypecType_PD:
            typeStr = @"PD";
            break;
        case BSPowerBankTypecType_QC:
            typeStr = @"QC";
            break;
        case BSPowerBankTypecType_SCP:
            typeStr = @"SCP";
            break;
        default:
            break;
    }
    return typeStr;
}

-(SelectTypeMessageView*)messageView {
    if (!_messageView) {
        _messageView = [SelectTypeMessageView new];
        [_messageView initAddView];
    }
    return _messageView;
}

-(SelectTypeMessageView*)protocolView {
    if (!_protocolView) {
        _protocolView = [SelectTypeMessageView new];
        [_protocolView initAddView];
    }
    return _protocolView;
}

-(SelectTypeMessageView*)deviceTypeView {
    if (!_deviceTypeView) {
        _deviceTypeView = [SelectTypeMessageView new];
        [_deviceTypeView initAddView];
    }
    return _deviceTypeView;
}

@end
#pragma mark   线材信息   view   ============ end




#pragma mark   开关选择 cellview   ============
@interface TypeSwitchCellView()
@property (nonatomic ,assign) NSInteger type;
@property (nonatomic, strong) UIView *bgView ;
@property (nonatomic, strong) UIImageView *iconView ;
@property (nonatomic, strong) UILabel *typeLab;
//@property (nonatomic, strong) UIImageView *iconRightView ;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation TypeSwitchCellView

-(void)initAddViewWithType:(NSInteger)typeView type:(NSString*)type icon:(NSString*)icon{ 
    _type = typeView;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.iconView];
    [self.bgView addSubview:self.typeLab];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(20);
    }];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(46);
        make.right.mas_equalTo(-108);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    if (_type == 1) {
        /// 开关类型
        [self.bgView addSubview:self.rightBtn];
        self.rightBtn.hidden = NO;
        self.iconRightView.hidden = YES;
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-35);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(28);
        }];
        
    } else if (_type == 2) {
        /// 图片类型
        [self.bgView addSubview:self.iconRightView];
        [self.iconRightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(45);
        }];
        self.iconRightView.image = [UIImage imageNamed:@"powerBank_home_set_screen_icon"];
        self.rightBtn.hidden = YES;
        self.iconRightView.hidden = NO;
    }
    self.iconView.image = [UIImage imageNamed:icon];
    self.typeLab.text = type;
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

-(UIImageView*)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

-(UIImageView*)iconRightView {
    if (!_iconRightView) {
        _iconRightView = [[UIImageView alloc]init];
        _iconRightView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconRightView;
}

-(UIButton*)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"powerBank_home_set_close"] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"powerBank_home_set_open"] forState:UIControlStateSelected];
        _rightBtn.bs_touchInset = UIEdgeInsetsMake(-20, -20, -20, -20);
        _rightBtn.hidden = YES ;
    }
    return _rightBtn;
}

-(UILabel*)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel bs_labelWithFont:[UIFont bs_regularFontWithFontSize:14] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#757589"]] ;
    }
    return _typeLab;
}
@end

#pragma mark   开关选择 cellview   ============ end





#pragma mark   电池信息 view   ============
@interface BatteryInfoView()
@property (nonatomic ,assign) NSInteger type;
@property (nonatomic, strong) UIView *bgView ;
@property (nonatomic, strong) UIImageView *iconView ;
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *typeNumberLab;
@property (nonatomic, strong) UILabel *typeBatteryLab;
@property (nonatomic, strong) UILabel *batteryNumberLab;
@property (nonatomic, strong) UILabel *batteryLab;
@property (nonatomic, strong) UIView *lineView ;
@end

@implementation BatteryInfoView

-(void)initAddView {
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.infoLab];
    [self.bgView addSubview:self.rightBtn];
    [self.bgView addSubview:self.typeLab];
    [self.bgView addSubview:self.typeNumberLab];
    [self.bgView addSubview:self.typeBatteryLab];
    [self.bgView addSubview:self.batteryNumberLab];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.iconView];
    [self.iconView addSubview:self.batteryLab];
    
    CGFloat sp_left = 24;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.top.mas_equalTo(24);
        make.right.mas_equalTo(-70);
        make.height.mas_equalTo(28);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-sp_left);
        make.centerY.equalTo(self.infoLab.mas_centerY).offset(0);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(12);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.top.equalTo(self.infoLab.mas_bottom).offset(16);
        make.width.mas_equalTo(96);
        make.height.mas_equalTo(96);
    }];
    [self.batteryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.mas_centerY).offset(0);
        make.left.equalTo(self.iconView.mas_right).offset(32);
        make.right.mas_equalTo(-sp_left);
        make.height.mas_equalTo(1);
    }];
    
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineView.mas_top).offset(-12);
        make.left.equalTo(self.lineView.mas_left).offset(0);
    }];
    
    [self.typeNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeLab.mas_centerY).offset(0);
        make.right.equalTo(self.lineView.mas_right).offset(0);
    }];
    
    [self.typeBatteryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(12);
        make.left.equalTo(self.lineView.mas_left).offset(0);
    }];
    
    [self.batteryNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeBatteryLab.mas_centerY).offset(0);
        make.right.equalTo(self.lineView.mas_right).offset(0);
    }];
  
    self.infoLab.text = @"电池信息";
    self.typeLab.text = @"循环次数";
    self.typeNumberLab.text = @"--";
    self.typeBatteryLab.text = @"当前容量";
    self.batteryNumberLab.text = @"--";
    self.batteryLab.text = @"--";
}

-(void)updateForViewTotypeNumber:(NSInteger)typeNumber
                    batteryState:(NSInteger)batteryState
                   batteryNumber:(NSInteger)batteryNumber
                     isConnected:(BOOL)isConnected {
    if (!isConnected) {
        self.batteryNumberLab.text = @"--";
        self.batteryLab.text = @"--";
        self.typeNumberLab.text = @"--";
        
    } else {
        self.typeNumberLab.text = [[NSString alloc]initWithFormat:@"%ld次",typeNumber];
        self.batteryNumberLab.text = [[NSString alloc]initWithFormat:@"%ldmAh",batteryNumber];
        self.batteryLab.text = [[NSString alloc]initWithFormat:@"%ld%@",batteryState,@"%"];
    }
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

-(UIView*)lineView{
    if (!_lineView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor bs_colorFromARGB:@"#C5C4DB" alpha:0.1];
        _lineView = view;
    }
    return _lineView;
}

-(UILabel*)infoLab {
    if (!_infoLab) {
        _infoLab = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:20] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#757589"]] ;
    }
    return _infoLab;
}

-(UIButton*)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"powerBank_home_right_icon"] forState:UIControlStateNormal];
        _rightBtn.bs_touchInset = UIEdgeInsetsMake(-20, -50, -20, -50);
    }
    return _rightBtn;
}

-(UILabel*)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:14] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#757589"]] ;
    }
    return _typeLab;
}

-(UILabel*)typeNumberLab {
    if (!_typeNumberLab) {
        _typeNumberLab = [UILabel bs_labelWithFont:[UIFont bs_regularFontWithFontSize:18] textAlignment:NSTextAlignmentRight textColor:[UIColor bs_colorFromARGB:@"#191C1E"]] ;
    }
    return _typeNumberLab;
}

-(UILabel*)typeBatteryLab {
    if (!_typeBatteryLab) {
        _typeBatteryLab = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:14] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#757589"]] ;
    }
    return _typeBatteryLab;
}

-(UILabel*)batteryNumberLab {
    if (!_batteryNumberLab) {
        _batteryNumberLab = [UILabel bs_labelWithFont:[UIFont bs_regularFontWithFontSize:18] textAlignment:NSTextAlignmentRight textColor:[UIColor bs_colorFromARGB:@"#191C1E"]] ;
    }
    return _batteryNumberLab;
}

-(UIImageView*)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.image = [UIImage imageNamed:@"powerBank_home_battery_icon"];
    }
    return _iconView;
}

-(UILabel*)batteryLab {
    if (!_batteryLab) {
        _batteryLab = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:18] textAlignment:NSTextAlignmentCenter textColor:[UIColor bs_colorFromARGB:@"#28C335"]] ;
    }
    return _batteryLab;
}
@end
#pragma mark   电池信息 view   ============ end




@interface SegmentedView()
@property (nonatomic, strong) selectTypeView *selectView ;
@property (nonatomic, strong) TypeMessageView *messageView;
/// 小电流开关
@property (nonatomic, strong) TypeSwitchCellView *typeSwithView;
@property (nonatomic, strong) TypeSwitchCellView *typeBgLogView;
@property (nonatomic, strong) UIView *bgView ;
@property (nonatomic, assign) CGFloat itemNumber;
@end
@implementation SegmentedView

-(void)initAddView{
    [self addSubview: self.bgView];
    [self.bgView addSubview:self.selectView];
    [self.bgView addSubview:self.messageView];
    [self addSubview:self.typeSwithView];
    [self addSubview:self.typeBgLogView];
    [self addSubview:self.batteryView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(42);
    }];
    
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectView.mas_bottom).offset(16);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
    }];
    
    [self.typeSwithView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(24);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(61);
    }];
    
    [self.typeBgLogView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeSwithView.mas_bottom).offset(24);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(61);
    }];
    
    [self.batteryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeBgLogView.mas_bottom).offset(24);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(188);
        make.bottom.mas_equalTo(-30);
    }];
    
    self.selectView.arrItems = @[@"C1",@"C2",@"A1"];
    [self.typeSwithView initAddViewWithType:1 type:@"小电流模式" icon:@"powerBank_home_TCP"];
    [self.typeBgLogView initAddViewWithType:2 type:@"屏幕设置" icon:@"powerBank_home_set_screen"];
    
    // 1. 创建手势
     UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(putToLogView)];
     // 2. 允许其他控件响应触摸
     tapGesture.cancelsTouchesInView = NO;
     // 3. 添加手势
     [self.typeBgLogView addGestureRecognizer:tapGesture];
    
    [self addNotifications];
    [self initDataForView];
}

///  进入界面的时候更新数据
-(void)initDataForView {
    if (self.deviceModel.isConnected) {
        [self updateForTypeCMessage:0];
    }
}


- (void)addNotifications
{
    __weak typeof(self) weakSelf = self;
    [RACObserve(self.deviceModel, smallAMPType) subscribeNext:^(id  _Nullable x) {
        [weakSelf updateForDevice];
    }];
    
    [RACObserve(self.deviceModel, batteryState) subscribeNext:^(id  _Nullable x) {
        [weakSelf updateForBatteryView];
    }];
    
    self.selectView.dataDidChangedBlock = ^(NSInteger selectIndex) {
        [weakSelf updateForTypeCMessage:selectIndex];
    };
}


/// 更新小电流模式
-(void)updateForDevice {
    self.typeSwithView.rightBtn.selected = self.deviceModel.smallAMPType &&self.deviceModel.isConnected ;
}

/// 更新 电池信息
-(void)updateForBatteryView {

    [self.batteryView updateForViewTotypeNumber:self.deviceModel.batteryCyclesModel.typeValue
                                   batteryState:self.deviceModel.batteryState
                                  batteryNumber:self.deviceModel.batterySOCModel.typeValue
                                    isConnected:self.deviceModel.isConnected];
}

/// 更新 C口 材料信息
-(void)updateForTypeCMessage:(NSInteger)typeC {
    
    BSCommonDeviceTypeModel *model = self.deviceModel.typeC1;
    if (typeC == 0) {
        /// C1
        NSLog(@"C1接口材料");
        model = self.deviceModel.typeC1;
    } else if (typeC == 1) {
        /// C2
        NSLog(@"C2接口材料");
        model = self.deviceModel.typeC2;
    } else if (typeC == 2) {
        /// A
        NSLog(@"A接口材料");
        model = self.deviceModel.USBA1;
    }
    [self.messageView updataForViewWithModel:model isConnected:self.deviceModel.isConnected];
}

-(void)setDeviceModel:(BSPowerBankDevice *)deviceModel
{
    _deviceModel = deviceModel;
    self.typeSwithView.rightBtn.selected = deviceModel.smallAMPType &&deviceModel.isConnected ;
    [self updateForTypeCMessage:self.selectView.selectedIndex];
    [self updateForBatteryView];
}

-(void)clickSwith:(UIButton*)button {
    NSLog(@"点击请求数据");
    NSInteger number = !button.selected;
    [self.deviceModel writeWithSingleCommand:BSPowerBankCmdClock_RW_open cmdValue:number block:^(BOOL result, id  _Nullable responseDic) {
        
        if (result) {
            NSLog(@"点击请求数据写入数据成功");
            [self updateForSettingClock_RW_openWith:number];
            
        } else {
            
        }
    }];
}

-(void)putToLogView {
    
    PowerBankScreenSetViewController *VC = [[PowerBankScreenSetViewController alloc]init];
    VC.model = self.supVC.model;
    [self.supVC.navigationController pushViewController:VC animated:YES];
}

-(void)updateForSettingClock_RW_openWith:(BOOL)number{
    self.deviceModel.smallAMPType = number;
}

-(UIView*)bgView{
    if (!_bgView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor bs_colorFromARGB:@"#FFFFFF"];
        view.layer.cornerRadius = 32;
        _bgView = view;
    }
    return _bgView;
}

-(selectTypeView*)selectView{
    if (!_selectView) {
        _selectView = [selectTypeView new];
        [_selectView initAddView];
    }
    return _selectView;
}

-(TypeMessageView*)messageView {
    if (!_messageView) {
        _messageView = [TypeMessageView new];
        [_messageView initAddView];
    }
    return _messageView;
}

-(TypeSwitchCellView*)typeSwithView {
    if (!_typeSwithView) {
        _typeSwithView = [TypeSwitchCellView new];
        [_typeSwithView.rightBtn addTarget:self action:@selector(clickSwith:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeSwithView;
}

-(TypeSwitchCellView*)typeBgLogView {
    if (!_typeBgLogView) {
        _typeBgLogView = [TypeSwitchCellView new];
    }
    return _typeBgLogView;
}

-(BatteryInfoView*)batteryView {
    if (!_batteryView) {
        _batteryView = [BatteryInfoView new];
        [_batteryView initAddView];
    }
    return _batteryView;
}

@end
