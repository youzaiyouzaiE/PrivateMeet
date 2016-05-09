//
//  UserInfo.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "UserInfo.h"

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


@end
