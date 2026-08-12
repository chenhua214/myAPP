//
//  BSBLEResponse.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/13.
//

#import "BSBLEResponse.h"

@implementation BSBLEResponse

- (instancetype)init{
    self = [super init];
    if (self) {
        self.maxTimes = 1;
        self.delayInSeconds = 2;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"maxTimes:%d,data:%@",self.maxTimes,self.commandByte];
}

@end
