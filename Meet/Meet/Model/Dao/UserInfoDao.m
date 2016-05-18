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
        //// create table
        NSString *sql = [NSString stringWithFormat:@"create table IF NOT EXISTS %@ ('%@' text,'%@' text,'%@' INTEGER,'%@' text,'%@' text,'%@' text,'%@' text,'%@' INTEGER,'%@' text)",tableName,kBeanIdKey,k_User_userId,k_User_userType,k_User_name,k_User_city,k_User_country,k_User_headimgurl,k_User_sex,k_User_eMail];
        if ([self.db executeUpdate:sql]) {
            NSLog(@"表创建成功！");
        } else {
            NSLog(@"表创建失败！");
        }
    }
}

- (UserInfo *)mappingRs2Bean:(FMResultSet *)rs {
    [UserInfo shareInstance].idKey = [rs stringForColumn:kBeanIdKey];
    [UserInfo shareInstance].userType = [NSNumber numberWithInteger:[rs boolForColumn:k_User_userType]];
    [UserInfo shareInstance].name = [rs stringForColumn:k_User_name];
    [UserInfo shareInstance].city = [rs stringForColumn:k_User_city];
    [UserInfo shareInstance].country = [rs stringForColumn:k_User_country];
    [UserInfo shareInstance].headimgurl = [rs stringForColumn:k_User_headimgurl];
    [UserInfo shareInstance].sex = [NSNumber numberWithInteger:[rs boolForColumn:k_User_sex]];
    [UserInfo shareInstance].eMail = [rs stringForColumn:k_User_eMail];
    return [UserInfo shareInstance];
}

- (UserInfo *)selectUserWithUserLoginType {
    NSString *whereSql = [NSString stringWithFormat:@"%@ = %d ", k_User_userType,1];
    NSArray *loginUsers = [self selectWithWhere:whereSql];
    UserInfo *info = loginUsers.firstObject;
    if (!info) {
        return nil;
    }
    [[UserInfo shareInstance] mappingValuesFormUserInfo:info];
    return [UserInfo shareInstance];
}


- (NSString *)tableName {
    return tableName;
}

- (NSString *)description {
    return @"UserInfoDao";
}

@end
