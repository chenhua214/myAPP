//
//  BSMineModel.m
//  Beillen
//
//  Created by skychi on 2021/5/14.
//

#import "BSMineModel.h"

#define kDefaultCellHeight    56.0
#define kDefaultCellSpace     8.0

@implementation BSMineCellModel

+ (BSMineCellModel *)modelWithType:(BSMineCellType)type{
    BSMineCellModel *model = [BSMineCellModel new];
    model.font = [UIFont bs_mediumFontWithFontSize:16.0];
    model.textMaxWidth = kScreenWidth - 56 - 41 - 24 * 2; // title 左右间距
    model.type = type;
    return model;
}

- (void)setType:(BSMineCellType)type{
    _type = type;
    NSString *iconName;
    NSString *title;
    CGFloat top = 0;
    CGFloat bottom = 0;
    CGFloat rowHeight = 0;
    BSCellRectCorner corner = BSCellRectCornerNone;
    switch (_type) {
        case BSMineCellTypeShare:
            iconName = @"mine_list_share";
            title = NSLocalizedStringkey(@"device_share");
            corner = BSCellRectCornerTopLeftRight;
            rowHeight += kDefaultCellSpace;
            top = kDefaultCellSpace;
            break;
        case BSMineCellTypeMessages:
            iconName = @"mine_list_message";
            title = NSLocalizedStringkey(@"message_center");
            break;
        case BSMineCellTypeServiceCenter:
            iconName = @"mine_list_service_center";
            title = NSLocalizedStringkey(@"service_center");
            break;
        case BSMineCellTypeFeedback:
            iconName = @"mine_list_feedback";
            title = NSLocalizedStringkey(@"app_feedback");
            break;
        case BSMineCellTypeBuyGoods:
            iconName = @"mine_list_purchase";
            title = NSLocalizedStringkey(@"str_buy_product");
            break;
        case BSMineCellTypeAboutBaseus:
            iconName = @"mine_list_about";
            title = NSLocalizedStringkey(@"about_app");
            corner = BSCellRectCornerBottomLeftRight;
            break;
        case BSMineCellTypeSetting:
            iconName = @"mine_list_setting";
            title = NSLocalizedStringkey(@"my_setting");
            title = NSLocalizedString(@"my_setting", @"");
            rowHeight += kDefaultCellSpace;
            bottom = -kDefaultCellSpace;
            break;
        default:
            break;
    }
    rowHeight += MAX([title bs_sizeWithLabelWidth:self.textMaxWidth font:self.font].height, kDefaultCellHeight);
    NSLog(@"rowHeight:%f", rowHeight);
    self.iconName = iconName;
    self.title = title;
    self.corner = corner;
    self.top = top;
    self.bottom = bottom;
    self.rowHeight = rowHeight;
}

@end

@implementation BSMineSectionModel

+ (BSMineSectionModel *)modelWithTitle:(nullable NSString *)title models:(NSArray<BSMineCellModel *> *)models{
    BSMineSectionModel *model = [BSMineSectionModel new];
    model.title = title;
    model.models = [models copy];
    return model;
}

@end

@implementation BSMineModel

+ (NSArray<BSMineSectionModel *> *)datas{
//    BOOL isOtherHost =  [BSApiServer sharedInstance].isOtherEnvironment ;
    BSMineSectionModel *sectionOne ;
//    if (isOtherHost) {
//        sectionOne = [BSMineSectionModel modelWithTitle:nil
//                                                 models:
//                      @[
//            [BSMineCellModel modelWithType:BSMineCellTypeShare],
////            [BSMineCellModel modelWithType:BSMineCellTypeMessages],
////            [BSMineCellModel modelWithType:BSMineCellTypeServiceCenter],
////            [BSMineCellModel modelWithType:BSMineCellTypeFeedback],
//            [BSMineCellModel modelWithType:BSMineCellTypeAboutBaseus],
//            [BSMineCellModel modelWithType:BSMineCellTypeSetting]
//        ]];}
//    else
    {
        sectionOne = [BSMineSectionModel modelWithTitle:nil
                                                 models:
                      @[
            [BSMineCellModel modelWithType:BSMineCellTypeShare],
//            [BSMineCellModel modelWithType:BSMineCellTypeMessages],
//            [BSMineCellModel modelWithType:BSMineCellTypeServiceCenter],
            [BSMineCellModel modelWithType:BSMineCellTypeFeedback],
//            [BSMineCellModel modelWithType:BSMineCellTypeBuyGoods],
            [BSMineCellModel modelWithType:BSMineCellTypeAboutBaseus],
            [BSMineCellModel modelWithType:BSMineCellTypeSetting],
        ]];
    }
    return @[sectionOne];
}

+ (BOOL)shouldShowLoginWithType:(BSMineCellType)type{
    BOOL isLogin = [BSConfigManager sharedInstance].isLogin;
    return !isLogin && [[self needLoginTypes] containsObject:@(type)];
}

+ (BOOL)disabledWithType:(BSMineCellType)type{
    return IS_GUEST_MODE && [[self needLoginTypes] containsObject:@(type)];
}

+ (NSArray<NSNumber *> *)needLoginTypes{
    if (IS_GUEST_MODE) {
        return @[@(BSMineCellTypeShare)];
    }
    return @[@(BSMineCellTypeShare),
             @(BSMineCellTypeFeedback),
             @(BSMineCellTypeMessages)];
}

@end
