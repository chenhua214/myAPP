//
//  BSDeviceCRC.h
//
//
//  Created by wushuang on 2023/4/23.
//  Copyright © 2023 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSDeviceCRC : NSObject

+ (uint16_t)crcWithData:(NSData *)data;
+ (NSString*)sumOfData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
