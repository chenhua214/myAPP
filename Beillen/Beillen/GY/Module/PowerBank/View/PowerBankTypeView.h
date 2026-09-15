//
//  PowerBankTypeView.h
//  Beillen
//
//  Created by chenyi on 2026/8/30.
//

#import <UIKit/UIKit.h>
#import "BSPowerBankDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface PowerBankTypeView : UIView

@property (nonatomic,strong) BSCommonDeviceTypeModel *typeModel ;
-(void)initAddView;
@end

NS_ASSUME_NONNULL_END
