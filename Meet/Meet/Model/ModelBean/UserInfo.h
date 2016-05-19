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
extern NSString *const k_User_userType;
extern NSString *const k_User_name;
extern NSString *const k_User_city;
extern NSString *const k_User_country;
extern NSString *const k_User_headimgurl;
extern NSString *const k_User_sex;
extern NSString *const k_User_eMail;
extern NSString *const k_User_modifySex;

@interface UserInfo : BaseModel

@property (copy, nonatomic) NSString *userId;
@property (nonatomic, strong) NSNumber *userType;////0，1 （0为退出登录的用户，1为当前正在使用的用户）
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *headimgurl;
@property (strong, nonatomic) NSNumber *sex;
@property (copy, nonatomic) NSString *eMail;

////已经更改过性别 ？
@property (assign, nonatomic) NSInteger modifySex;



+ (instancetype)shareInstance;

- (void)mappingValuesFormUserInfo:(UserInfo *)user;//////DB use
- (void)mappingValuesFormWXUserInfo:(WXUserInfo *)wxUser;

- (NSDictionary *)dictionaryWithUserInfo;


@end
