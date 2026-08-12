//
//  UITableViewCell+BSAdditions.h
//  BaseusAPP
//
//  Created by skychi on 2021/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (BSAdditions)
+ (NSString *)reusableCellId;
+ (void)registerCellForTableView:(UITableView *)tableView;
+ (id)cellForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)addSectionCornerRadius:(CGFloat)cornerRadius forTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
