//
//  BSHomePageHeader.h
//  Beillen
//
//  Created by chenyi on 2026/9/26.
//

#import <UIKit/UIKit.h>
#import "BSHomeProfilesModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol BSHomePageHeaderDelegate <NSObject>
/// 首页-头部视图点击事件
- (void)homePageHeaderEventsWithType:(BSHomePageEventsType)eventsType;

@end

@interface BSHomePageHeader : UIView
/// 切换语言、更新内容
- (void)updateOnChangeLanguages;
@property (nonatomic, weak) id <BSHomePageHeaderDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
