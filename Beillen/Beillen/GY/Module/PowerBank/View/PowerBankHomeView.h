//
//  PowerBankHomeView.h
//  Beillen
//
//  Created by chenyi on 2026/8/29.
//

#import <UIKit/UIKit.h>
#import "BSPowerBankDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface PowerBankHomeView : UIView
@property (nonatomic,strong) BSPowerBankDevice *deviceModel ;
-(void)initAddView;
@end

NS_ASSUME_NONNULL_END
