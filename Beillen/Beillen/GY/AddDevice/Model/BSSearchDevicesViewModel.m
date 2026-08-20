//
//  BSSearchDevicesViewModel.m
//  JDKJAPP
//
//  Created by chenyi on 2026/7/13.
//

#import "BSSearchDevicesViewModel.h"
#import "BSBLEManager.h"
#import "NSString+BSCommon.h"
#import "YGSearchDeviceModel.h"
#import "BSBindDeviceViewModel.h"
#import "YGAddDeviceModel.h"


@interface BSSearchDevicesViewModel()
@property(nonatomic,assign) BOOL isSearching;
@property(nonatomic,strong) NSMutableArray<YGSearchDeviceModel *> *dataSoure;
@property(nonatomic,strong) NSMutableArray<NSString *> *deviceIds;//显示的设备[id]数组
@property(nonatomic,strong) NSDictionary<NSString *,DeviceTypeModel *> *deviceTypeDict; // {型号,类型}
@property(nonatomic,strong) BSBindDeviceViewModel *viewModel;
@property(nonatomic,strong) YGSearchDeviceModel *selectedDevice;//当前选中的设备(待添加的设备)
@property(nonatomic,  copy) callback reloadCallback;//刷新block
@property(nonatomic,strong) NSSet<NSString *> *avaliableModelSet; // 可用型号集合
@end



@implementation BSSearchDevicesViewModel
#pragma mark- Life cycle

+ (instancetype)initWithTypeDeviceDict:(NSDictionary *)deviceTypeDict
                           reloadBlock:(nullable callback)reloadBlock{
    BSSearchDevicesViewModel *model = [BSSearchDevicesViewModel new];
    model.deviceTypeDict = deviceTypeDict.copy;
    model.avaliableModelSet = [NSSet setWithArray:deviceTypeDict.allKeys];
    model.reloadCallback = reloadBlock;
    return model;
}

- (instancetype)init{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

#pragma mark- setup

- (void)setup{
    self.deviceIds = [NSMutableArray array];
    self.dataSoure = [NSMutableArray array];
}

#pragma mark- Public methods

- (void)resume{
    //如果正在扫描
    if(self.isSearching){ return; }
    self.isSearching = YES;
    //重置数据源
    [self resetDataSource];
    [BSBLEManager realTimeCallbackEnabled:YES];
    __weak typeof(self) weakSelf = self;
    [[BSBLEManager shareInstance] scanBLEDevicesWithModel:nil delayInSeconds:10 callback:^(BOOL finished, NSArray<BSDeviceBLE *> * _Nullable devices) {
        [weakSelf scanBLEDevicesFinished:finished devices:devices];
    }];
}

- (void)stopIfNeeded{
    if(!self.isSearching){ return; }
    [self stopSearch];
}

/// 添加设备
/// callback 需要跳转时
- (void)addDeviceWithCallback:(addBlock)callback{
    if(!callback){ return; }
    if(!self.selectedDevice || !self.selectedDevice.bleDevice || !self.typeModel){
        //参数异常
        callback(BSOperationStateError,nil,nil);
        return;
    }
    DeviceTypeModel *typeModel = self.typeModel;
//    if (![BSCommonDevice isSupportedDevice:typeModel.model]) {
//        //暂时不支持添加
//        callback(BSOperationStateUnSupport,nil,nil);
//        return;
//    }
//    if(IS_GUEST_MODE && self.typeModel.visitor == 1){
//        //不支持访客模式
//        callback(BSOperationStateNeedLogin,nil,nil);
//        return;
//    }
    __weak typeof(self) weakSelf = self;
    [self.viewModel bindDevice:self.selectedDevice.bleDevice
                          type:typeModel
                      callback:^(BOOL result, DeviceTypeModel * _Nullable typeModel, BSCommonDevice * _Nullable device) {
        if(!result){//发生错误
            callback(BSOperationStateError,typeModel,device);
            return;
        }
        //绑定成功或连接成功
//        if([weakSelf need2ConfigNetworkWithModel:typeModel.model]){
//            //连接成功,需要跳转至配网界面
//            callback(BSOperationStateConfigNetwork,typeModel,device);
//            return;
//        }
        //绑定成功
        callback(BSOperationStateBounded,typeModel,device);
    }];
}

- (BOOL)checked{
    return (self.selectedDevice != nil);
}

/// 是否有数据
- (BOOL)hasData{
    BOOL hasData = NO;
    @synchronized (self.dataSoure) {
        hasData = self.dataSoure.count > 0;
    }
    return hasData;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    @synchronized (self.dataSoure) {
        count = self.dataSoure.count;
    }
    return count;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (nullable YGSearchDeviceModel *)modelAtIndexPath:(NSIndexPath *)indexPath{
    @synchronized (self.dataSoure) {
        if(indexPath.row < 0 || indexPath.row > self.dataSoure.count){
            return nil;
        }
        return self.dataSoure[indexPath.row];
    }
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YGSearchDeviceModel *current = [self modelAtIndexPath:indexPath];
    if(self.selectedDevice && [self.selectedDevice.bleDevice.mac isEqualToString:current.bleDevice.mac]){ return; }
    self.selectedDevice.checked = NO;
    current.checked = YES;
    self.selectedDevice = current;
    [self callbackIfNeeded];
}

#pragma mark- Private methods

- (void)scanBLEDevicesFinished:(BOOL)finished devices:(NSArray<BSDeviceBLE *> * _Nullable)devices{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self buildDataWithDevices:devices];
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新数据
            [self callbackWithFinished:finished];
            //未扫描完成,直接返回
            if(!finished){ return; }
            //扫描完成,停止扫描
            [self stopSearch];
        });
    });
}

- (void)stopSearch{
    self.isSearching = NO;
    //停止扫描
    NSLog(@"停止扫描");
    [BSBLEManager realTimeCallbackEnabled:NO];
    [[BSBLEManager shareInstance] stopScanBLEDevices];
}

- (void)resetDataSource{
    @synchronized (self.dataSoure) {
        [self.dataSoure removeAllObjects];
    }
    @synchronized (self.deviceIds) {
        [self.deviceIds removeAllObjects];
    }
    self.selectedDevice = nil;
    [self callbackWithFinished:NO];
}

- (void)buildDataWithDevices:(nullable NSArray<BSDeviceBLE *> *)devices{
    @synchronized (self.dataSoure) {
        if (devices && devices.count > 0) {
            NSString *model = nil;
            for (BSDeviceBLE *bleDevice in devices) {
                model = bleDevice.name;
                if(![self.avaliableModelSet containsObject:model] || [self isExistsWithMac:bleDevice.mac]){}
                if( [self isExistsWithMac:bleDevice.mac]){
//                    /**以下两种情况直接跳过
//                     1. 如果可用的型号集合中不包括扫描到的的设备型号
//                     2. 如果已经添加过该设备
//                    */
                    continue;
                }
                YGSearchDeviceModel *deviceModel = [YGSearchDeviceModel new];
                deviceModel.bleDevice = bleDevice;
                deviceModel.checked   = [self isSameDevice:bleDevice];
                deviceModel.typeModel = [self typeModelWithModel:model];
                [self.dataSoure addObject:deviceModel];
            }
        }
    }
}

- (void)callbackIfNeeded{
    //未扫描时,代表扫描完成
    [self callbackWithFinished:!self.isSearching];
}

- (void)callbackWithFinished:(BOOL)finished{
    if(!self.reloadCallback){ return; }
    self.reloadCallback(finished);
}

#pragma mark- Utils

- (BOOL)need2ConfigNetworkWithModel:(NSString *)model{
    //通信类型
    if(!model || model.length == 0){
        return NO;
    }
    return NO;
//    return ([BSCommonDevice deviceCommunicationTypeWithModel:model] == BSDeviceCommunicationTypeBluetoothWiFi);
}

- (BOOL)isExistsWithMac:(NSString *)mac{
    BOOL isExist = NO;
    @synchronized (self.deviceIds) {
       isExist = [self.deviceIds containsObject:mac];
    }
    if(!isExist){//不存在的时候,直接添加上
        [self.deviceIds addObject:mac];
    }
    return isExist;
}

- (BOOL)isSameDevice:(BSDeviceBLE *)device{
    return self.selectedDevice && [self.selectedDevice.bleDevice.mac isEqualToString:device.mac];
}

- (DeviceTypeModel *)typeModelWithModel:(NSString *)model{
    if(!model || model.length == 0) { return nil; }
    DeviceTypeModel *type = [DeviceTypeModel new];
    [type initModelwithString:model];
    
//    @synchronized (self.deviceTypeDict) {
//        type =  self.deviceTypeDict[model];
//    }
    return type;
}

#pragma mark- Setters && Getters

- (BOOL)finished{
    return !self.isSearching;
}

- (BSBindDeviceViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [BSBindDeviceViewModel new];
    }
    return _viewModel;
}

- (DeviceTypeModel *)typeModel{
    DeviceTypeModel *model = self.selectedDevice.typeModel;
    model.isAutoBindProcess = YES;
    return model;
}


@end
