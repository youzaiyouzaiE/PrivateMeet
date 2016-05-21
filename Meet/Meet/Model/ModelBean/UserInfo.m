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
 NSString *const k_User_loginType = @"User_loginType";
 NSString *const k_User_name = @"User_name";
 NSString *const k_User_city = @"User_city";
 NSString *const k_User_country = @"User_country";
 NSString *const k_User_headimgurl = @"User_headimgurl";
 NSString *const k_User_sex = @"User_sex";
 NSString *const k_User_eMail = @"User_eMail";
 NSString *const k_User_modifySex = @"User_modifySex";

 NSString *const k_User_brithday = @"User_brithday";
 NSString *const k_User_height = @"User_height";
 NSString *const k_User_phoneNo = @"User_phoneNo";
 NSString *const k_User_WX_No = @"User_WX_No";
 NSString *const k_User_workCity = @"User_workCity";
 NSString *const k_User_income = @"User_income";
 NSString *const k_User_state = @"User_state";
 NSString *const k_User_home = @"User_home";
 NSString *const k_User_constellation = @"User_constellation";

@implementation UserInfo

+ (instancetype)shareInstance {
    static UserInfo *shareInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[UserInfo alloc] init];
//        shareInstance.userId = @"1234567890";
//        shareInstance.name = @"public";
    });
    return shareInstance;
}

- (void)mappingValuesFormUserInfo:(UserInfo *)user {
    self.idKey = user.idKey;
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [self setValue:[user valueForKey:key] forKey:key];
    }
}

- (void)mappingValuesFormWXUserInfo:(WXUserInfo *)wxUser {
    self.userId = wxUser.unionid;
    self.sex = wxUser.sex;
    self.headimgurl = wxUser.headimgurl;
    self.city = wxUser.city;
    self.country = wxUser.country;
    self.name = wxUser.nickname;
    self.loginType = [NSNumber numberWithInteger:1];
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
    return @[k_User_userId,k_User_loginType,k_User_name, k_User_city, k_User_country, k_User_headimgurl, k_User_sex, k_User_eMail,k_User_modifySex,k_User_brithday,k_User_height,k_User_phoneNo,k_User_WX_No,k_User_workCity,k_User_income,k_User_state,k_User_home,k_User_constellation];
}

- (NSArray *)valueArray {
    if (!_loginType) {
        _loginType = (NSNumber *)[NSNumber numberWithInteger:1];
    }
    if (!_eMail) {
        _eMail = (NSString *)[NSNull null];
    }
    if (!_modifySex) {
        _modifySex = 0;
    }
    if (!_brithday) {
        _brithday = (NSString *)[NSNull null];
    }
    if (!_height) {
        _height = (NSString *)[NSNull null];
    }
    if (!_phoneNo) {
        _phoneNo = (NSString *)[NSNull null];
    }
    if (!_WX_No) {
        _WX_No = (NSString *)[NSNull null];
    }
    if (!_workCity) {
        _workCity = (NSString *)[NSNull null];
    }
    if (!_income) {
        _income = (NSString *)[NSNull null];
    }
    if (!_state) {
        _state = (NSString *)[NSNull null];
    }
    if (!_home) {
        _home = (NSString *)[NSNull null];
    }
    if (!_constellation) {
        _constellation = (NSString *)[NSNull null];
    }
    
    return @[_userId,_loginType,_name,_city,_country,_headimgurl,_sex,_eMail,[NSNumber numberWithInt:_modifySex],_brithday,_height,_phoneNo,_WX_No,_workCity,_income,_state,_home,_constellation];
}

- (BOOL)deleteBean {
    return [[UserInfoDao shareInstance] deleteBeanWithIdKey:self.idKey];
}

- (NSString *)description {
    return @"SmallCaregoryBean";
}

@end
