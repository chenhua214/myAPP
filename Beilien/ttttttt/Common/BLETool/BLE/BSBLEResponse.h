//
//  BSBLEResponse.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^BSResponseBlock)(BOOL result, id _Nullable responseDic);
@interface BSBLEResponse : NSObject
@property (nonatomic, assign) int maxTimes; //最大重试次数
@property (nonatomic, assign) int delayInSeconds; //延迟时长
@property (nonatomic, strong) NSData *commandByte; //命令类型
@property (nonatomic,   copy) BSResponseBlock  commandBlock;  //回调
@end

NS_ASSUME_NONNULL_END
