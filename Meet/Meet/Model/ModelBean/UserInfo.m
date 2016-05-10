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


- (void)mappingValuesFormWXUserInfo:(WXUserInfo *)wxUser {
    self.userId = wxUser.unionid;
    self.sex = wxUser.sex;
    self.headimgurl = wxUser.headimgurl;
    self.city = wxUser.city;
    self.country = wxUser.country;
    self.name = wxUser.nickname;
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



@end
