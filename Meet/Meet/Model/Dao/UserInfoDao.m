//
//  UserInfoDao.m
//  Meet
//
//  Created by jiahui on 16/5/9.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "UserInfoDao.h"
#import "UserInfo.h"

static NSString *const tableName = @"UserInfoTable";

@implementation UserInfoDao


+ (instancetype)shareInstance {
    static UserInfoDao *shareInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[UserInfoDao  alloc] init];
    });
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self greateTable];
    }
    return self;
}

- (void)greateTable {
    FMResultSet *set = [self.db executeQuery:[NSString stringWithFormat:@"select count (*) from sqlite_master where type = 'table' and name = '%@'",tableName]];
    [set next];
    if ([set intForColumnIndex:0]) {
        //        NSLog(@"表已经存！");
    } else {
        
        
        
    }
}

- (NSString *)tableName {
    return tableName;
}

- (NSString *)description {
    return @"UserInfoDao";
}

@end
