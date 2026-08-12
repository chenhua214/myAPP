//
//  UITableViewCell+BSAdditions.m
//  BaseusAPP
//
//  Created by skychi on 2021/6/4.
//

#import "UITableViewCell+BSAdditions.h"

@implementation UITableViewCell (BSAdditions)

+ (NSString *)reusableCellId{
    return NSStringFromClass([self class]);
}

+ (void)registerCellForTableView:(UITableView *)tableView{
    [tableView registerClass:[self class] forCellReuseIdentifier:[self reusableCellId]];
}

+ (id)cellForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:[self reusableCellId] forIndexPath:indexPath];
}

- (void)addSectionCornerRadius:(CGFloat)cornerRadius forTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    NSInteger rows = [tableView numberOfRowsInSection:indexPath.section];
    NSInteger row = indexPath.row;
    if (indexPath.row == 0 || indexPath.row == rows - 1) {
        UIRectCorner corner;
        if (rows == 1) {
            corner = UIRectCornerAllCorners;
        }else if (row == 0){
            corner = UIRectCornerTopLeft | UIRectCornerTopRight;
        }else{
            corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        }
        CAShapeLayer *cornerLayer = [CAShapeLayer layer];
        cornerLayer.masksToBounds = YES;
        cornerLayer.frame = self.bounds;
        cornerLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
        self.layer.mask = cornerLayer;
    }else{
        self.layer.mask = nil;
    }
}

@end
