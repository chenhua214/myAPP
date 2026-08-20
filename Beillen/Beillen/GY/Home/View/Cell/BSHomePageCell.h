//
//  BSHomePageCell.h
//  Beillen
//
//  Created by chenyi on 2026/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BSHomeDeviceModel;

@protocol BSHomePageCellDelegate <NSObject>
/// 开关按钮点击事件
- (void)homePageCellSwitchTouchedWithModel:(BSHomeDeviceModel *)deviceModel;
@end

@interface BSHomePageCell : UICollectionViewCell

@property (nonatomic, strong) BSHomeDeviceModel *deviceModel;

@property (nonatomic, weak) id <BSHomePageCellDelegate> delegate;

/// 更新数据
- (void)updateDeviceModel:(BSHomeDeviceModel *)deviceModel;
@end

NS_ASSUME_NONNULL_END
