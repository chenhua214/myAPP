//
//  BSBindDeviceViewModel.m
//  JDKJAPP
//
//  Created by chenyi on 2026/7/13.
//

#import "BSBindDeviceViewModel.h"
#import "BSDeviceManager.h"
#import "BSBLEManager.h"
#import "BSGCDTimer.h"
#import "YGAddDeviceModel.h"

#import "BSHomeModel.h"

static NSString *const kBSConnectedTimeout  = @"connectedTimeout";
static NSString *const kBSWriteBindTimeout  = @"kBSWriteBindTimeout";
static NSString *const kBReadVersionTimeout = @"kBReadVersionTimeout";
static NSString *const kBSWriteInitTimeout  = @"kBSWriteInitTimeout";
static NSString *const kBSReadSnUuidTimeout = @"kBSReadSnUuidTimeout";
///已被其他人绑定错误码
static NSInteger kBoundByOtherErrorCode  = 100102;
///需要登录错误码
static NSInteger kNeedLoginErrorCode  = 401;


typedef void(^checkBindBlock)(BOOL result, NSInteger code, NSString *message);
@interface BSBindDeviceViewModel()<BSCommonDeviceDelegate>
@property(nonatomic,strong) BSCommonDevice *device;
@property(nonatomic,strong) DeviceTypeModel *typeModel;
@property(nonatomic,  copy) connectBlock callback;
@property(nonatomic,strong) BSDeviceBLE *bleDevice;
@property(nonatomic,assign) BOOL readedSnUuid; ///< 已经读取到设备SN、UUID
@end



@implementation BSBindDeviceViewModel
- (void)dealloc{
    [[BSGCDTimer shareInstance] cancelTimerWithName:kBSConnectedTimeout];
    [[BSGCDTimer shareInstance] cancelTimerWithName:kBSWriteBindTimeout];
    [[BSGCDTimer shareInstance] cancelTimerWithName:kBReadVersionTimeout];
    [[BSGCDTimer shareInstance] cancelTimerWithName:kBSReadSnUuidTimeout];
}

#pragma mark- Public methods

- (void)bindDevice:(BSDeviceBLE *)bleDevice type:(DeviceTypeModel *)typeModel callback:(nullable connectBlock)callback{
    self.typeModel = typeModel;
    [self bindDevice:bleDevice callback:callback];
}

- (void)bindDevice:(BSDeviceBLE *)bleDevice callback:(nullable connectBlock)callback{
    if(!callback){ return; }
    self.callback  = callback;
    if(!bleDevice || !self.typeModel){
        //参数错误
        [self callbackWithResult:NO];
        return;
    }
    self.bleDevice = bleDevice ;
//    if (bleDevice.longMac.length == 35) {
//        self.device = [[BSDeviceManager shareInstance] deviceWithIdentifier:bleDevice.longMac type:self.typeModel.type model:self.typeModel.model];
//        self.device.mainIdentifier = bleDevice.mac ;
//    } else {
        self.device = [[BSDeviceManager shareInstance] deviceWithIdentifier:bleDevice.mac type:self.typeModel.type model:self.typeModel.model];
        self.device.mainIdentifier = bleDevice.mac ;
//    }
    if (!self.device) {
        [self callbackWithResult:NO];
        return;
    }
    self.readedSnUuid = NO;
    self.device.delegate = self;
    [self showHud];
    [self.device connect];
    [self connectTimeoutHandler];
}


#pragma mark- Private methods

- (void)toBindDevice:(BSCommonDevice * _Nonnull)device{
//    BSDeviceType type = self.typeModel.type;
//    BSDeviceSubType subtype = [BSCommonDevice deviceSubTypeWithModel:self.typeModel.model];
//    if ([device isChargerStationDevices]) {
//        // 充电桩查询sn、uuid
////        [self chargerStationDelayReadSnUuidWithDevice:device];
//    }else if (type == BSDeviceTypeInCarProduct){
//        //车载产品
////        [self checkDeviceDidResetedWithDevice:device];
//    }else if (type == BSDeviceTypeLifeOffice) {
//        //生活办公
//        [self readInfomationWithDevice:device];
//    }else if (type == BSDeviceTypeOutdoorPower && ( subtype == BSDeviceSubTypeStoreEnergyPES600W || subtype == BSDeviceSubTypeEnergyMergePPS450W || subtype == BSDeviceSubTypeEnergyBaseusPPS140 || subtype == BSDeviceSubTypeEnergyMergePPS140W || subtype == BSDeviceSubTypeEnergyMergePPS420W)) {
//        //户外电源且为储能
////        [self readEnergyValueWithDevice:device];
//    }else if (type == BSDeviceTypeOutdoorPower && (subtype == BSDeviceSubTypeEnergyMergeBPM600W  || subtype == BSDeviceSubTypeEnergyMergePPS450W || subtype == BSDeviceSubTypeEnergyMergePPS140W)) {
//        //户外电源且为储能
//        [self readEnergyValueWithDevice:device withSubType:subtype];
//    }else if (type == BSDeviceTypeCleanProduct && subtype == BSDeviceSubTypeSmartWashingMachine){
//        //洗地机
////        [self washingMachineWriteInitCommandWithDevice:device];
//    }else {
        [self bindDeviceWithDevice:device];
//    }
}

- (void)bindDeviceWithDevice:(BSCommonDevice *)device{
    [self syncData2Device:device];
//    if(IS_GUEST_MODE){
        //如果是访客模式,则将设备添加至本地数据库
        BSHomeDeviceModel *model = [self modelWithDevice:device];
        [BSGuestModeHelper insertToDBWithObject:model callback:^(BOOL result, id  _Nullable responseData) {
            [self addDevice:device success:result];
        }];
        return;
//    }
//    NSMutableDictionary *dicParam = @{@"model":self.typeModel.model,@"name" :self.typeModel.prodName,@"sn":device.identifier}.mutableCopy;
//    if (device.serial) [dicParam setValue:device.serial forKey:@"serial"];
//    
//    __weak typeof(self) weakSelf = self;
//    [BSHomeNetWorkTool devicebindWithParam:dicParam success:^(id data) {
//        BSBaseModel *model = [BSBaseModel yy_modelWithDictionary:data];
//        if (!model || model.code != 0) {
//            [weakSelf showAlertWithCode:model.code message:model.message sn:device.identifier];
//            [weakSelf addDevice:device success:NO];
//            return;
//        }
//        [weakSelf readVersionWithDevice:device];
//    } fail:^(id data) {
//        [weakSelf addDevice:device success:NO];
//    }];
}


- (void)readVersionWithDevice:(BSCommonDevice *)device{
    [self addReadVersionTimeoutHandlerWithDevice:device];
    __weak typeof(self) weakSelf = self;
    double time = 0.8;
//    if ([device isChargerStationDevices]) time = 1.2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [device readDeviceVersionWithResponseBlock:^(BOOL result, id responseDic) {
          
            [[BSGCDTimer shareInstance] cancelTimerWithName:kBReadVersionTimeout];
//            [weakSelf uploadVersionWithDevice:device version:responseDic];
        }];
    });
}


//- (void)chargerStationDelayReadSnUuidWithDevice:(BSCommonDevice *)device{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSTimeInterval timeInterval = kChargerStationPairedTimeout + kChargerStationSNUUIDTimeout;
//        [self chargerStationReadSnUuidWithDevice:device repeat:timeInterval]; // 总共读取36s时间，配对弹窗会显示：一代30s 二代25s
//    });
//}


- (void)addDevice:(BSCommonDevice *)device success:(BOOL)success{
    [self hideHud];
    if (!success) {
        [device disconnect];
//        [self uploadEventWithDataType:BSTrackingDataTypeDeviceBand success:NO];
        [self callbackWithResult:NO];
        return;
    }
    [[BSDeviceManager shareInstance] addDevice:device];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSHomeRefreshNotification object:nil];
    
    [self addDeviceSuccess];
}

- (void)addDeviceSuccess{
    if(IS_GUEST_MODE){//访客模式成功埋点
//        [self uploadEventWithDataType:BSTrackingDataTypeAppGuestModeDeviceBindingSuccess success:YES];
    }else{
//        [self uploadEventWithDataType:BSTrackingDataTypeDeviceBand success:YES];
    }
    //成功回调
    [self callbackWithResult:YES];
}

///   弹框提示
- (void)showAlertWithCode:(NSInteger)code message:(NSString *)message sn:(NSString *)sn{
    if(!message || message.length == 0){ return; }
    if(code == kBoundByOtherErrorCode){
        [self showBindFailedAlertWithErrorMessage:message sn:sn];
        return;
    }
    if(code != kNeedLoginErrorCode){
        [self showAddFailedAlertWithMessage:message];
        return;
    }
}


- (void)showAddFailedAlertWithMessage:(NSString *)message{
    [BSAlertMessageTool alertMessage:NSLocalizedStringkey(@"add_failure")
                          subMessage:message
                           actionTxt:NSLocalizedStringkey(@"str_confirm")
                              handle:nil];
}

- (void)showBindFailedAlertWithErrorMessage:(NSString *)message sn:(NSString *)sn{
    if (!sn || sn.length == 0) { return; }
    [BSAlertMessageTool alertMessage:NSLocalizedStringkey(@"add_failure")
                          subMessage:message
                           cancelTxt:NSLocalizedStringkey(@"str_turn_back")
                           actionTxt:NSLocalizedStringkey(@"apply_unbind")
                              handle:^(BSAlertMessageAction action, id object) {
        if (action != BSAlertMessageActionEvents) { return; }
        [self deviceUnbindApplyWithSN:sn];
    }];
}


#pragma mark- Utils

- (void)checkDevice:(BSCommonDevice *)device isBind:(BOOL)relieveBind{
    [self checkDevice:device isBind:relieveBind should2NextBlock:nil];
}

- (void)checkDevice:(BSCommonDevice *)device isBind:(BOOL)relieveBind should2NextBlock:(nullable checkBindBlock)should2NextBlock{
    __weak typeof(self) weakSelf = self;
    [self deviceIsBind:relieveBind callback:^(BOOL result,NSInteger code,NSString *message) {
        if(should2NextBlock){
            should2NextBlock(result,code,message);
            return;
        }
        if(!result){
            [weakSelf hideHud];
            if (message.length > 0) {
                [weakSelf showHint:message];
            }
            [weakSelf callbackWithResult:NO];
            return;
        }
        [self bindDeviceWithDevice:device];
    }];
}


- (void)deviceIsBind:(BOOL)relieveBind callback:(nullable checkBindBlock)callback{
    if(!callback){ return; }
    if(IS_GUEST_MODE){
        //访客模式,默认未绑定
        callback(YES,0,nil);
        return;
    }
    
    /// 绑定后台
//    [BSHomeNetWorkTool deviceAlreadyBindWithParamSN:self.device.identifier
//                                              model:self.typeModel.model
//                                        relieveBind:relieveBind
//                                            success:^(id data) {
//        BSBaseModel *model = [BSBaseModel yy_modelWithDictionary:data];
//        if(model && model.code == 100102) {
//            //已被其他账号绑定
//            callback(NO,model.code, model.message ?: @"");
//            return;
//        }
//        if (!model || model.code != 0) {
//            callback(NO, model.code, nil);
//            return;
//        }
//        callback(YES,0, nil);
//    } fail:^(id data) {
//        callback(NO,-1, nil);
//    }];
}


- (void)deviceUnbindApplyWithSN:(NSString *)sn{
    if (!sn || sn.length == 0) { return; }
//    [BSHomeNetWorkTool deviceUnbindApplyWithParam:@{@"model":self.typeModel.model?:@"",@"sn":sn}
//                                          success:^(id data) {
//        if (data && [data isKindOfClass:[NSDictionary class]]) {
//            BSBaseModel *model = [BSBaseModel yy_modelWithDictionary:data];
//            if (model && model.code == 0) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [NSObject showHint:NSLocalizedStringkey(@"feedback_success")];
//                });
//            }
//        }
//    } fail:^(id data) {}];
}

/// 生成model数据
/// @param device  设备
- (BSHomeDeviceModel *)modelWithDevice:(BSCommonDevice *)device {
    BSHomeDeviceModel *model = [BSHomeDeviceModel new];
    model.bindTime = ceil([[NSDate date] timeIntervalSince1970] * 1000);
    model.started = 0;
    model.isUnbundling = NO;
    model.sn = model.identifier = device.identifier;
    model.deviceType = device.deviceType;
    model.model = device.model;
//    model.deviceImgUrl = device.deviceImgUrl;
    model.name = model.prodName = device.name;
//    model.des = device.des;
    model.started = 0;
    model.categoryId = device.categoryId;
//    model.gestureUrl = device.gestureUrl;
//    model.fqa = device.fqa;
//    model.feedback = device.feedback;
//    [[BSDeviceResourceDownloader instance] syncData2Device:model];
    return model;
}

- (void)syncData2Device:(BSCommonDevice *)device{
    if (device && self.typeModel) {
        device.model = self.typeModel.model;
//        device.deviceImgUrl = self.typeModel.icon;
        device.name = self.typeModel.prodName;
//        device.des = self.typeModel.des;
//        device.categoryId = self.typeModel.categoryId;
//        device.gestureUrl = self.typeModel.gestureUrl;
//        device.fqa = self.typeModel.fqa;
//        device.feedback = self.typeModel.feedback;
    }
}

- (void)callbackWithResult:(BOOL)success{
    if(!self.callback){ return; }
    self.callback(success, self.typeModel, self.device);
}

#pragma mark- Timeout Handler

- (void)connectTimeoutHandler{
    NSTimeInterval timeInterval = 10;
//    if(self.device.deviceSubType == BSDeviceSubTypeSmartWashingMachine) timeInterval = kWashingMachineConnectTimeout;
//    else if ([self.device isChargerStationDevices]) timeInterval = kChargerStationPairedTimeout + kChargerStationSNUUIDTimeout + 5/*缓冲*/;
    [self connectTimeoutHandlerWithTimInterval:timeInterval];
}

- (void)connectTimeoutHandlerWithTimInterval:(NSTimeInterval)timeInterval{
    //连接超时定时器
    dispatch_queue_t queue = dispatch_queue_create("timeQueue", DISPATCH_QUEUE_CONCURRENT);
    __weak typeof(self) weakSelf = self;
    [[BSGCDTimer shareInstance] scheduledDispatchTimerWithName:kBSConnectedTimeout timeInterval:timeInterval queue:queue repeats:NO actionOption:AbandonPreviousAction action:^{
        [[BSGCDTimer shareInstance] cancelTimerWithName:kBSConnectedTimeout];
        dispatch_async(dispatch_get_main_queue(), ^{
            //连接超时
            [weakSelf hideHud];
            [weakSelf.device disconnect];
            [weakSelf showAddFailedAlert];
            [weakSelf callbackWithResult:NO];
        });
    }];
}

- (void)checkDeviceDidResetedTimeoutHandlerWithDevice:(BSCommonDevice *)device{
    // 查询重置
    dispatch_queue_t queue = dispatch_queue_create("timeQueue", DISPATCH_QUEUE_CONCURRENT);
    __weak typeof(self) weakSelf = self;
    [[BSGCDTimer shareInstance] scheduledDispatchTimerWithName:kBSWriteBindTimeout timeInterval:10 queue:queue repeats:NO actionOption:AbandonPreviousAction action:^{
        [[BSGCDTimer shareInstance] cancelTimerWithName:kBSWriteBindTimeout];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            [weakSelf checkDevice:device isBind:1];
        });
    }];
}


- (void)energyDeviceReadValueTimeoutHandlerWithDevice:(BSCommonDevice *)device{
    dispatch_queue_t queue = dispatch_queue_create("timeQueue", DISPATCH_QUEUE_CONCURRENT);
    __weak typeof(self) weakSelf = self;
    [[BSGCDTimer shareInstance] scheduledDispatchTimerWithName:kBSWriteBindTimeout timeInterval:3 queue:queue repeats:NO actionOption:AbandonPreviousAction action:^{
        [[BSGCDTimer shareInstance] cancelTimerWithName:kBSWriteBindTimeout];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            [weakSelf bindDeviceWithDevice:device];
        });
    }];
}

- (void)addReadVersionTimeoutHandlerWithDevice:(BSCommonDevice *)device{
    // 查询版本
    dispatch_queue_t queue = dispatch_queue_create("timeQueue", DISPATCH_QUEUE_CONCURRENT);
    __weak typeof(self) weakSelf = self;
    [[BSGCDTimer shareInstance] scheduledDispatchTimerWithName:kBReadVersionTimeout timeInterval:3 queue:queue repeats:NO actionOption:AbandonPreviousAction action:^{
        [[BSGCDTimer shareInstance] cancelTimerWithName:kBReadVersionTimeout];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf addDevice:device success:YES];
        });
    }];
}

- (void)washingMachineWriteInitTimeoutHandler{
    [self writeInitCommandTimeoutHandlerWithInterval:5];
}

- (void)writeInitCommandTimeoutHandlerWithInterval:(double)interval {
    dispatch_queue_t queue = dispatch_queue_create("wifitimeQueue", DISPATCH_QUEUE_CONCURRENT);
    __weak typeof(self) weakSelf = self;
    [[BSGCDTimer shareInstance] scheduledDispatchTimerWithName:kBSWriteInitTimeout timeInterval:interval queue:queue repeats:NO actionOption:AbandonPreviousAction action:^{
        [[BSGCDTimer shareInstance] cancelTimerWithName:kBSWriteInitTimeout];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            [weakSelf.device disconnect];
            [weakSelf showAddFailedAlert];
            [weakSelf callbackWithResult:NO];
        });
    }];
}

- (void)showAddFailedAlert {
    NSString *subMsg1 = NSLocalizedStringkey(@"set_failed_tip1") ;
    NSString *subMsg2 = NSLocalizedStringkey(@"set_failed_tip2") ;
    NSString *subMsg3 = NSLocalizedStringkey(@"set_failed_tip3") ;
    NSString *subMsg4 = NSLocalizedStringkey(@"set_failed_tip4") ;
    NSString *subMsg = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",subMsg1,subMsg2,subMsg3,subMsg4];
    [self showAddFailedAlertWithMessage:subMsg];
    // [self showAddFailedAlertWithMessage:NSLocalizedStringkey(@"connect_timeout")];
}

#pragma mark - BSCommonDeviceDelegate

- (void)didConnectWithDevice:(BSCommonDevice *)device{
    [[BSGCDTimer shareInstance] cancelTimerWithName:kBSConnectedTimeout];
    [self toBindDevice:device];
}

- (void)didDisConnectWithDevice:(BSCommonDevice *)device{
    [self hideHud];
    [self gcdTimerCancelWithName:kBSReadSnUuidTimeout];
    [self gcdTimerCancelWithName:kBSConnectedTimeout];
//    if ([device isChargerStationDevices] && !self.readedSnUuid) [self showAddFailedAlert];
}


@end
