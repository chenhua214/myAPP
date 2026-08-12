//
//  BSBaseDBModel.m
//  BaseusAPP
//
//  Created by skychi on 2022/9/9.
//  Copyright © 2022 Baseus. All rights reserved.
//

#import "BSBaseDatabaseModel.h"

@implementation BSBaseDatabaseModel

+ (NSDictionary *)getTableMapping{
    return nil;
}

+ (void)dbDidCreateTable:(LKDBHelper *)helper tableName:(NSString *)tableName{
    NSLog(@"dbDidCreateTable :%@",tableName);
}

+ (void)dbDidInserted:(NSObject *)entity result:(BOOL)result{
    NSLog(@"dbDidInserted");
}

+ (void)dbDidUpdated:(NSObject *)entity result:(BOOL)result{
    NSLog(@"dbDidUpdated");
}

+ (void)dbDidDeleted:(NSObject *)entity result:(BOOL)result{
    NSLog(@"dbDidDeleted");
}

@end
