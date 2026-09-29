//
//  YLCustomTabBar.h
//  Beillen
//
//  Created by chenyi on 2026/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol CustomFloatingTabBarDelegate <NSObject>
- (void)floatingTabBarDidSelectIndex:(NSInteger)index;
@end

@interface YLCustomTabBar : UIView
@property (nonatomic, weak) id<CustomFloatingTabBarDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)setupItemsWithTitles:(NSArray<NSString *> *)titles
                   normalImages:(NSArray<NSString *> *)normalImages
                 selectedImages:(NSArray<NSString *> *)selectedImages;
@end

NS_ASSUME_NONNULL_END
