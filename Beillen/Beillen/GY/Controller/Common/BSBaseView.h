//
//  BSBaseView.h
//  Beillen
//
//  Created by  wang on 2021/1/14.
//

#import <UIKit/UIKit.h>

typedef void(^defaultBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface BSBaseView : UIView
@property(nonatomic, copy, nullable) defaultBlock callback;
@end

NS_ASSUME_NONNULL_END
