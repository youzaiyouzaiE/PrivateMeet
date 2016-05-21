//
//  UserInfoDao.h
//  Meet
//
//  Created by jiahui on 16/5/9.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "SuperDao.h"

@interface UserInfoDao : SuperDao

+ (instancetype)shareInstance;

- (UserInfo *)selectUserWithUserLoginType;
- (UserInfo *)selectUserInfoWithUserId:(NSString *)userId;

@end
