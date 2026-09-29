//
//  PowerBankMessageViewController.m
//  Beillen
//
//  Created by chenyi on 2026/9/28.
//

#import "PowerBankMessageViewController.h"
#import "BSPowerBankDevice.h"
#import "BSDeviceManager.h"
#import "MessageCellView.h"

typedef NS_ENUM(NSInteger, NSCellModelType) {
    ///< 放电
    NSCellModelType_SOC           = 1 ,     ///电池健康
    NSCellModelType_battary       = 2 ,     /// 电池型号
    NSCellModelType_Number        = 3 ,    /// 循环次数
    NSCellModelType_cell          = 4 ,    /// 电芯
    NSCellModelType_deviceInfo    = 5 ,    /// 功率
    NSCellModelType_inputTime     = 6 ,    /// 放电数据
};


@interface PowerBankMessageViewController ()
@property (nonatomic, strong) BSPowerBankDevice *device;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) MessageBgCellView *battarySOCBgView;  // 电池健康
@property (nonatomic, strong) UIImageView *SOCbgView;
@property (nonatomic, strong) NSArray <MessageCellModel*>* battarySOCModelAarr;

@property (nonatomic, strong) MessageBgCellView *battaryModelBgView;  // 电池型号
@property (nonatomic, strong) NSArray <MessageCellModel*>* battaryModelAarr;

@property (nonatomic, strong) MessageBgCellView *battaryNumberBgView;   // 循环次数
@property (nonatomic, strong) NSArray <MessageCellModel*>* battaryNumberModelAarr;

@property (nonatomic, strong) MessageBgCellView *cellBgView;  // 电芯数
@property (nonatomic, strong) NSArray <MessageCellModel*>* cellModelAarr;

@property (nonatomic, strong) MessageBgCellView *deviceInfoBgView;   // 功率
@property (nonatomic, strong) NSArray <MessageCellModel*>* deviceInfoModelAarr;

@property (nonatomic, strong) MessageBgCellView *inputTimeBgView;   // 放电数据
@property (nonatomic, strong) NSArray <MessageCellModel*>* inputTimeModelAarr;

@end

@implementation PowerBankMessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self bs_showNavigationBarWithAnimated:animated];
}

- (void)viewDidLoad {
    self.notLoadTableView = YES;
    [super viewDidLoad];
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    self.device = (BSPowerBankDevice *)[[BSDeviceManager shareInstance] findDeviceWithIdentifier:self.model.sn];
    self.view.backgroundColor  = self.bs_backgroundColor  = [UIColor bs_colorFromARGB:@"F6F8FA"];
    self.title = @"电池信息";
    [self updateBackImgAndTitleFonts];

    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-30);
    }];
    
    [self updateForArrModel];
    [self createUI];
    [self readDeviceMessage];
}

- (void)createUI{
    CGFloat sp_left = 24;
    MessageBgCellView *bgView =[MessageBgCellView new];
    [self.scrollView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(214 );
        make.width.mas_equalTo(self.scrollView).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    self.battarySOCBgView  = bgView;
    
    self.SOCbgView = [UIImageView new];
    self.SOCbgView.image = [UIImage imageNamed:@"home_bannerTest"];
    [self.battarySOCBgView addSubview:self.SOCbgView];
    [self.SOCbgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    //    self.battarySOCBgView    = [self addBgCellViewWihtArr:self.battarySOCModelAarr ];
    self.battaryModelBgView  = [self addBgCellViewWihtArr:self.battaryModelAarr ];
    self.battaryNumberBgView = [self addBgCellViewWihtArr:self.battaryNumberModelAarr  ];
    self.cellBgView          = [self addBgCellViewWihtArr:self.cellModelAarr  ];
    self.deviceInfoBgView    = [self addBgCellViewWihtArr:self.deviceInfoModelAarr  ];
    self.inputTimeBgView     = [self addBgCellViewWihtArr:self.inputTimeModelAarr  ];
    
    [self.battarySOCBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(24);
    }];
    [self.battaryModelBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.battarySOCBgView.mas_bottom).offset(sp_left);
    }];
    [self.battaryNumberBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.battaryModelBgView.mas_bottom).offset(sp_left);
    }];
    [self.cellBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.battaryNumberBgView.mas_bottom).offset(sp_left);
    }];
    [self.deviceInfoBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellBgView.mas_bottom).offset(sp_left);
    }];
    [self.inputTimeBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deviceInfoBgView.mas_bottom).offset(sp_left);
        make.bottom.mas_equalTo(self.scrollView).offset(-20);
    }];
}

-(void)readDeviceMessage {
    if (self.device.isConnected) {
        //  请求健康度、循环次数 cell1-cell6
       [self.device readValueWithStartCommand:BSPowerBankCmdBattery_LoopNum_L_Read endCommand:BSPowerBankCmdCELL7V_H_Read block:^(BOOL result, id  _Nullable responseDic) {
            
        }];
        //  请求健康度、循环次数 cell1-cell6
       [self.device readValueWithStartCommand:BSPowerBankCmdBattery_R_Time_L endCommand:BSPowerBankCmdBattery_R_Sum_H block:^(BOOL result, id  _Nullable responseDic) {
           [self updateForView];
        }];
    }
}

-(void)updateForView {
    [self updateForArrModel];
    [self.scrollView removeAllSubviews];
    [self createUI];
}

-(void)updateForArrModel {
    //    self.battarySOCModelAarr    = [self addCellModeWiht:NSCellModelType_SOC];
    self.battaryModelAarr       = [self addCellModeWiht:NSCellModelType_battary];
    self.battaryNumberModelAarr = [self addCellModeWiht:NSCellModelType_Number];
    self.cellModelAarr          = [self addCellModeWiht:NSCellModelType_cell];
    self.deviceInfoModelAarr    = [self addCellModeWiht:NSCellModelType_deviceInfo];
    self.inputTimeModelAarr     = [self addCellModeWiht:NSCellModelType_inputTime];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(MessageBgCellView*)addBgCellViewWihtArr:(NSArray<MessageCellModel *> *)modelArr {
    
    MessageBgCellView *bgView =[MessageBgCellView new];
    [self.scrollView addSubview:bgView];
    CGFloat viewHeight = 64;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(viewHeight*modelArr.count + 18);
        make.width.mas_equalTo(self.scrollView).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    bgView.modelArr = modelArr;
    return bgView;
}

-(NSArray*)addCellModeWiht:(NSCellModelType)cellType
{
    NSArray *arrModel ;
    if (cellType == NSCellModelType_SOC) {
//        MessageCellModel *model = [self addCellModelWithTypeStr:@"" messageStr:@""
//                                                        iconStr:@"" typeTag:1 typeView:1 isLineShow:YES];
//        MessageCellModel *model2 = [self addCellModelWithTypeStr:@"" messageStr:@""
//                                                         iconStr:@"" typeTag:1 typeView:1 isLineShow:NO];
//        arrModel = [[NSArray alloc]initWithObjects:model,model2, nil];
    } else  if (cellType == NSCellModelType_battary) {
        MessageCellModel *model = [self addCellModelWithTypeStr:@"电池生产厂" messageStr:@"SUNPOWER"
                                                        iconStr:@"" typeTag:1 typeView:1 isLineShow:YES];
        MessageCellModel *model2 = [self addCellModelWithTypeStr:@"电池型号" messageStr:@"INR21700-5000"
                                                       iconStr:@"" typeTag:2 typeView:1 isLineShow:NO];
        arrModel = [[NSArray alloc]initWithObjects:model,model2, nil];
        
    } else  if (cellType == NSCellModelType_Number) {
        
        NSString *messageStr = [[NSString alloc]initWithFormat:@"%ld次",self.device.batteryCyclesModel.typeValue];
        
        MessageCellModel *model = [self addCellModelWithTypeStr:@"循环次数" messageStr:messageStr
                                                        iconStr:@"" typeTag:1 typeView:1 isLineShow:YES];
        MessageCellModel *model2 = [self addCellModelWithTypeStr:@"建议使用时间" messageStr:@"5年"
                                                       iconStr:@"" typeTag:2 typeView:1 isLineShow:NO];
        arrModel = [[NSArray alloc]initWithObjects:model,model2, nil];
        
    } else  if (cellType == NSCellModelType_cell) {
        
        NSString *messageStr2 = [[NSString alloc]initWithFormat:@"%ldmV",self.device.batteryCell_1.typeValue];
        NSString *messageStr3 = [[NSString alloc]initWithFormat:@"%ldmV",self.device.batteryCell_2.typeValue];
        NSString *messageStr4 = [[NSString alloc]initWithFormat:@"%ldmV",self.device.batteryCell_3.typeValue];
        NSString *messageStr5 = [[NSString alloc]initWithFormat:@"%ldmV",self.device.batteryCell_4.typeValue];
        NSString *messageStr6 = [[NSString alloc]initWithFormat:@"%ldmV",self.device.batteryCell_5.typeValue];
        
        MessageCellModel *model = [self addCellModelWithTypeStr:@"电池串数" messageStr:@"5S"
                                                        iconStr:@"" typeTag:1 typeView:1 isLineShow:YES];
        MessageCellModel *model2 = [self addCellModelWithTypeStr:@"电芯1电压" messageStr:messageStr2
                                                       iconStr:@"powerBank_cell_icon" typeTag:2 typeView:2 isLineShow:YES];
        MessageCellModel *model3 = [self addCellModelWithTypeStr:@"电芯2电压" messageStr:messageStr3
                                                        iconStr:@"powerBank_cell_icon" typeTag:3 typeView:2 isLineShow:YES];
        MessageCellModel *model4 = [self addCellModelWithTypeStr:@"电芯3电压" messageStr:messageStr4
                                                       iconStr:@"powerBank_cell_icon" typeTag:4 typeView:2 isLineShow:YES];
        MessageCellModel *model5 = [self addCellModelWithTypeStr:@"电芯4电压" messageStr:messageStr5
                                                        iconStr:@"powerBank_cell_icon" typeTag:5 typeView:2 isLineShow:YES];
        MessageCellModel *model6 = [self addCellModelWithTypeStr:@"电芯5电压" messageStr:messageStr6
                                                         iconStr:@"powerBank_cell_icon" typeTag:6 typeView:2 isLineShow:NO];
        arrModel = [[NSArray alloc]initWithObjects:model,model2,model3,model4,model5,model6, nil];
        
    } else  if (cellType == NSCellModelType_deviceInfo) {
        MessageCellModel *model = [self addCellModelWithTypeStr:@"额定功率" messageStr:@"310W"
                                                        iconStr:@"" typeTag:1 typeView:1 isLineShow:YES];
        MessageCellModel *model2 = [self addCellModelWithTypeStr:@"最大充电功率" messageStr:@"140W"
                                                       iconStr:@"" typeTag:2 typeView:1 isLineShow:YES];
       
        MessageCellModel *model3 = [self addCellModelWithTypeStr:@"最大放电功率" messageStr:@"300W"
                                                         iconStr:@"" typeTag:3 typeView:1 isLineShow:NO];
        arrModel = [[NSArray alloc]initWithObjects:model,model2,model3, nil];
        
    } else  if (cellType == NSCellModelType_inputTime) {
        NSInteger time = self.device.outpuSumTimeModel.typeValue;
        NSInteger time_H = time/60 ;
        NSInteger time_M = time%60 ;
        NSString *messageStr1 = [[NSString alloc]initWithFormat:@"%ld 小时 %ld 分钟",time_H,time_M];

        NSString *messageStr2 = [[NSString alloc]initWithFormat:@"%ldmV",self.device.outpuSumMAHModel.typeValue];
        MessageCellModel *model = [self addCellModelWithTypeStr:@"累计放电时长" messageStr:messageStr1
                                                        iconStr:@"" typeTag:1 typeView:1 isLineShow:YES];
        MessageCellModel *model2 = [self addCellModelWithTypeStr:@"累计放电量" messageStr:messageStr2
                                                         iconStr:@"" typeTag:2 typeView:1 isLineShow:NO];
        arrModel = [[NSArray alloc]initWithObjects:model,model2, nil];
        
    }
    return  arrModel;
}

-(MessageCellModel*) addCellModelWithTypeStr:(NSString*)typeStr
                                  messageStr:(NSString*)messageStr
                                     iconStr:(NSString*)iconStr
                                     typeTag:(NSInteger)typeTag
                                    typeView:(NSInteger)typeView
                                  isLineShow:(BOOL)isLineShow {
    MessageCellModel *model = [MessageCellModel new];
    model.typeStr = typeStr;
    model.messageStr = messageStr;
    model.iconStr = iconStr;
    model.typeTag = typeTag;
    model.typeView = typeView;
    model.isLineShow = isLineShow;
    return model;
}

@end
