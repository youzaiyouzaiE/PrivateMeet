//
//  WXAccessModel.m
//  Meet
//
//  Created by jiahui on 16/5/7.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "WXAccessModel.h"

#define Access_Token_LostTime    2*60*60
#define Refresh_Token_LostTime   30*24*60*60

@implementation WXAccessModel

+ (instancetype)shareInstance {
    static WXAccessModel *shareInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[WXAccessModel alloc] init];
    });
    return shareInstance;
}


- (BOOL)isLostAccess_token
{
//    NSDate *lostDate = [_saveDate dateByAddingTimeInterval:Access_Token_LostTime];
    if (!_saveDate) {
        return YES;
    }
    NSDate *currentDate = [AppData curretnDate];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:_saveDate];
    BOOL isLost = (timeBetween > Access_Token_LostTime) ? YES:NO;
    return isLost;
}

- (BOOL)isLostRefresh_token
{
    if (!_saveDate) {
        return YES;
    }
    NSDate *currentDate = [AppData curretnDate];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:_saveDate];
    BOOL isLost = (timeBetween > Refresh_Token_LostTime) ?  YES:NO;
    return isLost;
}


#pragma - NScoding
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.errcode = [decoder decodeObjectForKey:@"errcode"];
    self.errmsg = [decoder decodeObjectForKey:@"errmsg"];
    self.access_token = [decoder decodeObjectForKey:@"access_token"];
    self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
    self.refresh_token = [decoder decodeObjectForKey:@"refresh_token"];
    self.openid = [decoder decodeObjectForKey:@"openid"];
    self.scope = [decoder decodeObjectForKey:@"scope"];
    self.unionid = [decoder decodeObjectForKey:@"unionid"];
    self.saveDate = [decoder decodeObjectForKey:@"saveDate"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.errcode forKey:@"errcode"];
    [encoder encodeObject:self.errmsg forKey:@"errmsg"];
    [encoder encodeInteger:self.access_token forKey:@"access_token"];
    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
    [encoder encodeBool:self.refresh_token forKey:@"refresh_token"];
    [encoder encodeObject:self.openid forKey:@"openid"];
    [encoder encodeObject:self.scope forKey:@"scope"];
    [encoder encodeInteger:self.unionid forKey:@"unionid"];
    [encoder encodeObject:self.saveDate forKey:@"saveDate"];
}


@end
