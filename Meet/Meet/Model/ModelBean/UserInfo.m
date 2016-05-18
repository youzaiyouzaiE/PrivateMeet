//
//  UserInfo.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "UserInfo.h"
#import "UserInfoDao.h"
#import <objc/runtime.h>

 NSString *const k_User_userId = @"User_userId";
 NSString *const k_User_userType = @"User_userType";
 NSString *const k_User_name = @"User_name";
 NSString *const k_User_city = @"User_city";
 NSString *const k_User_country = @"User_country";
 NSString *const k_User_headimgurl = @"User_headimgurl";
 NSString *const k_User_sex = @"User_sex";
 NSString *const k_User_eMail = @"User_eMail";

@implementation UserInfo

+ (instancetype)shareInstance {
    static UserInfo *shareInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[UserInfo alloc] init];
        shareInstance.userId = @"1234567890";
        shareInstance.name = @"public";
    });
    return shareInstance;
}

- (void)mappingValuesFormUserInfo:(UserInfo *)user {
    self.idKey = user.idKey;
    self.userId = user.userId;
    self.sex = user.sex;
    self.headimgurl = user.headimgurl;
    self.city = user.city;
    self.country = user.country;
    self.name = user.name;
    self.userType = user.userType;
}

- (void)mappingValuesFormWXUserInfo:(WXUserInfo *)wxUser {
    self.userId = wxUser.unionid;
    self.sex = wxUser.sex;
    self.headimgurl = wxUser.headimgurl;
    self.city = wxUser.city;
    self.country = wxUser.country;
    self.name = wxUser.nickname;
    self.userType = [NSNumber numberWithInteger:1];
}

- (NSDictionary *)dictionaryWithUserInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:[self valueForKey:key] forKey:key];
    }
    free(properties);
    return [NSDictionary dictionaryWithDictionary:dict];
}


#pragma mark - DB use
- (NSArray *)columnArray {
    return @[k_User_userId,k_User_userType,k_User_name, k_User_city, k_User_country, k_User_headimgurl, k_User_sex, k_User_eMail];
}

- (NSArray *)valueArray {
    return @[_userId,_userType,_name,_city,_country,_headimgurl,_sex,_eMail];
}

- (BOOL)deleteBean {
    return [[UserInfoDao shareInstance] deleteBeanWithIdKey:self.idKey];
}

- (NSString *)description {
    return @"SmallCaregoryBean";
}

@end
