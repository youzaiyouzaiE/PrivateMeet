//
//  UserInfo.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "BaseModel.h"
#import "WXUserInfo.h"



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
