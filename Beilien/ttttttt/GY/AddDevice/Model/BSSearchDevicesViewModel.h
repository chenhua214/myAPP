//
//  BSSearchDevicesViewModel.h
//  JDKJAPP
//
//  Created by chenyi on 2026/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,BSOperationState) {
    BSOperationStateError,//存在错误
    BSOperationStateUnSupport,//暂不支持
    BSOperationStateBounded,//已绑定
    BSOperationStateConfigNetwork,//配网(WiFi设备)
    BSOperationStateNeedLogin//需要登录
};

@class YGSearchDeviceModel;
@class DeviceTypeModel;
@class BSCommonDevice;
typedef void(^callback)(BOOL finished);
typedef void(^addBlock)(BSOperationState state,DeviceTypeModel *_Nullable typeModel,BSCommonDevice *_Nullable device);


@interface BSSearchDevicesViewModel : NSObject

@property(nonatomic,assign,readonly) BOOL isSearching;
+ (instancetype)initWithTypeDeviceDict:(NSDictionary *)deviceTypeDict
                           reloadBlock:(nullable callback)reloadBlock;

/// 重启扫描设备
- (void)resume;

/// 停止扫描,如有必要
- (void)stopIfNeeded;

/// 添加设备
/// result = YES
/// callback 回调 <类型,数据>
- (void)addDeviceWithCallback:(nullable addBlock)callback;

/// 是否选中
- (BOOL)checked;

/// 是否有数据
- (BOOL)hasData;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (nullable YGSearchDeviceModel *)modelAtIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
