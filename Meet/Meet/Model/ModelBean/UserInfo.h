//
//  UserInfo.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "BaseModel.h"
#import "WXUserInfo.h"

extern NSString *const k_User_userId;
extern NSString *const k_User_name;
extern NSString *const k_User_city;
extern NSString *const k_User_country;
extern NSString *const k_User_headimgurl;
extern NSString *const k_User_sex;


@interface UserInfo : BaseModel

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *headimgurl;
@property (strong, nonatomic) NSNumber *sex;


+ (instancetype)shareInstance;
- (void)mappingValuesFormWXUserInfo:(WXUserInfo *)wxUser;


@end
