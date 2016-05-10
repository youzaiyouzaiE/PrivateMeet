//
//  AppDelegate.h
//  Meet
//
//  Created by jiahui on 16/4/28.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *keyAccessModelSave = @"accessModelSaveKey";
static NSString *keyWXUserInfo = @"WeChatUserInfoKey";
static NSString *keyUserInfo = @"k_UserInfoDic";


@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
-(MainViewController *)getRootViewController;


- (void)wechatLoginByRequestForUserInfo;
- (void)weChatRefreshAccess_Token;
@end

