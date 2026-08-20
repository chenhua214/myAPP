//
//  BSBaseTableViewCell.m
//  Beillen
//
//  Created by  wang on 2021/1/18.
//

#import "BSBaseTableViewCell.h"

@implementation BSBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configNewUI {}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.radius > 0 && self.tableView != nil && self.indexPath != nil){
        [self addSectionCornerRadius:self.radius forTableView:self.tableView atIndexPath:self.indexPath];
    }
}
@end
