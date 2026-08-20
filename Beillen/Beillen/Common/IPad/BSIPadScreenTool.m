//
//  BSIPadScreenTool.m
//  Beillen
//
//  Created by jy w on 2024/3/19.
//  Copyright © 2024 Beillen.All rights reserved.
//

#import "BSIPadScreenTool.h"

@implementation BSIPadScreenTool

+ (instancetype)shareInstance {
    static BSIPadScreenTool *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[BSIPadScreenTool alloc] init];
    });
    return share;
}

@end
