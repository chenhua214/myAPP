//
//  PowerBankModelCellView.h
//  Beillen
//
//  Created by chenyi on 2026/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PowerBankModelCellView : UIView
@property (nonatomic, strong) UIButton *selectBtn;
-(void)initAddViewWithType:(NSInteger)typeView;
@end

NS_ASSUME_NONNULL_END
