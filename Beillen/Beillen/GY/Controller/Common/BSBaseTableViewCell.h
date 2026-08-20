//
//  BSBaseTableViewCell.h
//  Beillen
//
//  Created by  wang on 2021/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSBaseTableViewCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,strong) UITableView * tableView;
- (void)configNewUI;
@end

NS_ASSUME_NONNULL_END
