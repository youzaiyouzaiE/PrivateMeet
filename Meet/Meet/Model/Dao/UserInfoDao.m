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
        NSString *sql = [NSString stringWithFormat:@"create table IF NOT EXISTS %@ ('%@' text,'%@' text,'%@' INTEGER,'%@' text,'%@' text,'%@' text,'%@' text,'%@' INTEGER,'%@' text, '%@' INTEGER,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text)",tableName,kBeanIdKey,k_User_userId,k_User_loginType,k_User_name,k_User_city,k_User_country,k_User_headimgurl,k_User_sex,k_User_eMail,k_User_modifySex,k_User_brithday,k_User_height,k_User_phoneNo,k_User_WX_No,k_User_workCity,k_User_income,k_User_state,k_User_home,k_User_constellation];
        if ([self.db executeUpdate:sql]) {
            NSLog(@"表创建成功！");
        } else {
            NSLog(@"表创建失败！");
        }
    }
}

- (UserInfo *)mappingRs2Bean:(FMResultSet *)rs {
    UserInfo *model = [[UserInfo alloc] init];
    model.idKey = [rs stringForColumn:kBeanIdKey];
    model.userId = [rs stringForColumn:k_User_userId];
    model.loginType = [NSNumber numberWithInteger:[rs intForColumn:k_User_loginType]];
    model.name = [rs stringForColumn:k_User_name];
    model.city = [rs stringForColumn:k_User_city];
    model.country = [rs stringForColumn:k_User_country];
    model.headimgurl = [rs stringForColumn:k_User_headimgurl];
    model.sex = [NSNumber numberWithInteger:[rs intForColumn:k_User_sex]];
    model.eMail = [rs stringForColumn:k_User_eMail];
    model.modifySex = [rs intForColumn:k_User_modifySex];
    
    model.brithday = [rs stringForColumn:k_User_brithday];
    model.height = [rs stringForColumn:k_User_height];
    model.phoneNo = [rs stringForColumn:k_User_phoneNo];
    model.WX_No = [rs stringForColumn:k_User_WX_No];
    model.workCity = [rs stringForColumn:k_User_workCity];
    model.income = [rs stringForColumn:k_User_income];
    model.state = [rs stringForColumn:k_User_state];
    model.home = [rs stringForColumn:k_User_home];
    model.constellation = [rs stringForColumn:k_User_constellation];
    return model;
}

- (UserInfo *)selectUserWithUserLoginType {
    NSString *whereSql = [NSString stringWithFormat:@"%@ = %d ", k_User_loginType,1];
    NSArray *loginUsers = [self selectWithWhere:whereSql];
    UserInfo *info = loginUsers.firstObject;
    if (!info) {
        return nil;
    }
    [[UserInfo shareInstance] mappingValuesFormUserInfo:info];
    return [UserInfo shareInstance];
}

- (UserInfo *)selectUserInfoWithUserId:(NSString *)userId {
    NSString *whereSql = [NSString stringWithFormat:@"%@ = '%@' ", k_User_userId,userId];
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
