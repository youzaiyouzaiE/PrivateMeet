//
//  WXAccessModel.h
//  Meet
//
//  Created by jiahui on 16/5/7.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "BaseModel.h"

@interface WXAccessModel : BaseModel/////微信登录时获取AccessToken后得到的数据

+ (instancetype)shareInstance;

@property (strong, nonatomic)NSNumber *errcode;
@property (copy, nonatomic) NSString *errmsg;

@property (copy, nonatomic) NSString *access_token;///接口调用凭证 (2个小时)
@property (copy, nonatomic) NSString *expires_in;///access_token接口调用凭证超时时间，单位（秒）
@property (copy, nonatomic) NSString *refresh_token;////用户刷新access_token(refresh_token拥有较长的有效期（30天），当refresh_token失效的后，需要用户重新授权。)
@property (copy, nonatomic) NSString *openid;///授权用户唯一标识
@property (copy, nonatomic) NSString *scope;////用户授权的作用域，使用逗号（,）分隔
@property (copy, nonatomic) NSString *unionid;/// 当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段

@property (strong, nonatomic) NSDate *saveDate;////存入时间，查看是否过期；


- (BOOL)isLostAccess_token;
- (BOOL)isLostRefresh_token;

@end
