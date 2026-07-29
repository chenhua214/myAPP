//
//  BSAddCell.h
//  BaseusAPP
//
//  Created by baseus_ouyang on 2021/2/4.
//

#import <UIKit/UIKit.h>
#import "BSDeviceBLE.h"
NS_ASSUME_NONNULL_BEGIN

@interface BSAddCell : UITableViewCell
- (void)setIconURL:(nullable NSString *)iconURL name:(NSString *)name mac:(NSString *)mac checked:(BOOL)checked;
- (void)setIconURL:(nullable NSString *)iconURL name:(NSString *)name mac:(NSString *)mac checked:(BOOL)checked backgroundColorHexString:(nullable NSString *)backgroundColorHexString;
@end

NS_ASSUME_NONNULL_END
