//
//  BSMineListCell.h
//  BaseusAPP
//
//  Created by  wang on 2021/1/19.
//

#import "BSBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BSMineListCell : BSBaseTableViewCell

/// 设置信息
/// @param imageName icon name
/// @param title 标题
/// @param corner 圆角类型
//- (void)setIconNamed:(NSString *)imageName title:(NSString *)title corner:(BSCellRectCorner)corner;

/// 设置信息
/// @param imageName icon name
/// @param title 标题
/// @param corner 圆角类型
/// @param disabled 是否禁用
- (void)setIconNamed:(NSString *)imageName title:(NSString *)title corner:(BSCellRectCorner)corner disabled:(BOOL)disabled top:(CGFloat)top bottom:(CGFloat)bottom;

@end

NS_ASSUME_NONNULL_END
