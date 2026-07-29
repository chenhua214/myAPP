//
//  BSIPadScreenTool.h
//  BaseusAPP
//
//  Created by jy w on 2024/3/19.
//  Copyright © 2024 Baseus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSIPadScreenTool : NSObject

@property (assign, nonatomic) CGSize screenSize;

+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
