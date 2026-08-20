//
//  BSBaseModel.h
//  Beillen
//
//  Created by  wang on 2021/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSBaseModel : NSObject
@property (nonatomic, assign) NSInteger code;//0:成功,401:认证失效,其他:异常
@property (nonatomic, assign) NSInteger status;//(已弃用,请使用code)
@property (nonatomic, copy,nullable) NSString  *message;//(成功时为空,异常时为异常说明信息)
@property (nonatomic, strong) id data;//NSArray,NSDictionary
@end

NS_ASSUME_NONNULL_END
