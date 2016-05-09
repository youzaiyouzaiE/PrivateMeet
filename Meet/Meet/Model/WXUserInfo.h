//
//  WXUserInfo.h
//  Meet
//
//  Created by jiahui on 16/5/7.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "BaseModel.h"

/////详见微信API https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317853&lang=zh_CN

@interface WXUserInfo : BaseModel/////微信用户获取到的用户信息

+ (instancetype)shareInstance;

@property (copy, nonatomic) NSString *unionid;//////用户维一标识
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *headimgurl;
@property (copy, nonatomic) NSString *language;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *openid;
@property (copy, nonatomic) NSArray *privilege;
@property (copy, nonatomic) NSString *province;
@property (strong, nonatomic) NSNumber *sex;//////1为男  2为女


@end
