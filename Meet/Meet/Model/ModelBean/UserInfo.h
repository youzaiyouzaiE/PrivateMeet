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
extern NSString *const k_User_loginType;
extern NSString *const k_User_name;
extern NSString *const k_User_city;
extern NSString *const k_User_country;
extern NSString *const k_User_headimgurl;
extern NSString *const k_User_sex;
extern NSString *const k_User_eMail;
extern NSString *const k_User_modifySex;

extern NSString *const k_User_brithday;
extern NSString *const k_User_height;
extern NSString *const k_User_phoneNo;
extern NSString *const k_User_WX_No;
extern NSString *const k_User_workCity;
extern NSString *const k_User_income;
extern NSString *const k_User_state;
extern NSString *const k_User_home;
extern NSString *const k_User_constellation;

@interface UserInfo : BaseModel

@property (copy, nonatomic) NSString *userId;
@property (nonatomic, strong) NSNumber *loginType;////0，1 （0为退出登录的用户，1为当前正在使用的用户）
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *headimgurl;
@property (strong, nonatomic) NSNumber *sex;/////1为男  2为女(因为是和微信同步，所以也这样设置了，)
@property (copy, nonatomic) NSString *eMail;
////已经更改过性别 ？
@property (assign, nonatomic) NSInteger modifySex;
@property (copy, nonatomic) NSString *brithday;
@property (copy, nonatomic) NSString *height;
@property (copy, nonatomic) NSString *phoneNo;
@property (copy, nonatomic) NSString *WX_No;
@property (copy, nonatomic) NSString *workCity;
@property (copy, nonatomic) NSString *income;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *home;
@property (copy, nonatomic) NSString *constellation;



+ (instancetype)shareInstance;

- (void)mappingValuesFormUserInfo:(UserInfo *)user;//////DB use
- (void)mappingValuesFormWXUserInfo:(WXUserInfo *)wxUser;

- (NSDictionary *)dictionaryWithUserInfo;


@end
