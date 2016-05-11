//
//  MyProfileViewController.h
//  Meet
//
//  Created by jiahui on 16/4/30.
//  Copyright © 2016年 Meet. All rights reserved.
//

#define  FRIST_LOGIN_NOTIFICATION_Key  @"modifiUserInfoNotification"

typedef void(^needReloadProfileCellBlock)(BOOL updateImaeg,BOOL updateInfo);

#import <UIKit/UIKit.h>

@interface MyProfileViewController : UIViewController

@property (assign, nonatomic) BOOL isFristLogin;///////第一次登录进入的

@property (copy, nonatomic) needReloadProfileCellBlock block;

@end
