//
//  MessageCellView.h
//  Beillen
//
//  Created by chenyi on 2026/9/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageCellModel : NSObject
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSString *messageStr;
@property (nonatomic, strong) NSString *iconStr;
@property (nonatomic, assign) NSInteger typeView;
@property (nonatomic, assign) NSInteger typeTag;
@property (nonatomic, assign) BOOL isLineShow;
@end

@interface MessageCellView : UIView
@property (nonatomic, strong) UILabel *messageLab;
-(void)initAddViewWithType:(NSInteger)typeView
                      type:(NSString*)type
                   message:(NSString*)message
                      icon:(NSString*)icon
                  showLine:(BOOL)hidden;
@end



@interface MessageBgCellView : UIView
@property (nonatomic, strong) NSArray<MessageCellModel *> *modelArr;
-(void)upDataWithModelArr:(NSArray<MessageCellModel *> *)modelArr;
@end

NS_ASSUME_NONNULL_END
