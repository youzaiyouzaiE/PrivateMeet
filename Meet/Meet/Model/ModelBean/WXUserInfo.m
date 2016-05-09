//
//  WXUserInfo.m
//  Meet
//
//  Created by jiahui on 16/5/7.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "WXUserInfo.h"

@implementation WXUserInfo

+ (instancetype)shareInstance {
    static WXUserInfo *shareInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[WXUserInfo  alloc] init];
    });
    return shareInstance;
}


@end
