//
//  PowerBankScreenSetView.h
//  Beillen
//
//  Created by chenyi on 2026/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PowerBankScreenSetViewDelegate <NSObject>
/// 按钮点击事件代理
- (void)eventsDidTouched:(NSInteger)eventsType value:(NSInteger)value;

@end

@interface PowerBankScreenSetCellView : UIView
-(void)initAddViewWithType:(NSInteger)typeView;
@end


@interface PowerBankScreenSetView : UIView
/// 按钮点击事件代理
@property (nonatomic, weak) id <PowerBankScreenSetViewDelegate> delegate;
-(void)initAddViewWithType:(NSInteger)typeView;
@end

NS_ASSUME_NONNULL_END
