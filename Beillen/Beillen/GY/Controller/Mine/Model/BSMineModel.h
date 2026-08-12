//
//  BSMineModel.h
//  BaseusAPP
//
//  Created by skychi on 2021/5/14.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,BSMineCellType) {
    BSMineCellTypeShare,//设备分享
    BSMineCellTypeMessages,//消息中心
    BSMineCellTypeServiceCenter,//服务中心
    BSMineCellTypeFeedback,//意见反馈
    BSMineCellTypeAccountSecurity,//账号安全
    BSMineCellTypeRegion,//地区
    BSMineCellTypeSetting,//设置
    BSMineCellTypeAboutBaseus,// 关于倍思
    BSMineCellTypeBuyGoods,// 商品购买
};

NS_ASSUME_NONNULL_BEGIN

@interface BSMineCellModel : NSObject
@property (nonatomic,   copy) NSString *iconName;
@property (nonatomic,   copy) NSString *title;
@property (nonatomic, assign) BSMineCellType type;
@property (nonatomic, assign) BSCellRectCorner corner;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat textMaxWidth;
@end

@interface BSMineSectionModel : NSObject
@property (nonatomic,   copy) NSString *title;
@property (nonatomic, strong) NSArray<BSMineCellModel *> *models;
@end

@interface BSMineModel : NSObject
+ (NSArray<BSMineSectionModel *> *)datas;
+ (BOOL)shouldShowLoginWithType:(BSMineCellType)type;
+ (BOOL)disabledWithType:(BSMineCellType)type;
@end

NS_ASSUME_NONNULL_END
