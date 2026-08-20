//
//  UICollectionViewCell+BSAdditions.m
//  Beillen
//
//  Created by skychi on 2021/5/17.
//

#import "UICollectionViewCell+BSAdditions.h"

@implementation UICollectionViewCell (BSAdditions)

+ (NSString *)reusableCellId{
    return NSStringFromClass([self class]);
}

+ (void)registerCellForCollectionView:(UICollectionView *)collectionView{
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:[self reusableCellId]];
}

+ (id)cellForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:[self reusableCellId] forIndexPath:indexPath];
}

- (void)addSectionCornerRadius:(CGFloat)cornerRadius forCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath{
    NSInteger rows = [collectionView numberOfItemsInSection:indexPath.section] ;
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
