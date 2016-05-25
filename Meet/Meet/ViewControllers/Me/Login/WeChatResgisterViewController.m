//
//  WeChatResgisterViewController.m
//  Meet
//
//  Created by jiahui on 16/5/6.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "WeChatResgisterViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXAccessModel.h"
#import "WXUserInfo.h"
//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>
#import "UserInfoDao.h"

@interface WeChatResgisterViewController ()<UIGestureRecognizerDelegate>

@end

@implementation WeChatResgisterViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IOS_7LAST) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action
- (void)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)tapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)checkCodeButtonAction:(id)sender {
#warning check code and into WeChat Longin
    [self performSegueWithIdentifier:@"pushToWXLogin" sender:self];
    
}

- (IBAction)useWeChatLogin:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oldUerLoginState:) name:@"OldUserLoginWihtWechat" object:nil];
//    if (![WXAccessModel shareInstance].isLostAccess_token) {
//        [SHARE_APPDELEGATE wechatLoginByRequestForUserInfo];
//        return ;
//    }
//    if (![WXAccessModel shareInstance].isLostRefresh_token) {
//        [SHARE_APPDELEGATE weChatRefreshAccess_Token];
//        return ;
//    }
        [self sendAuthRequest];
}

#pragma mark - NSNotificationCenter
- (void)oldUerLoginState:(NSNotification *)notification {
    ////可按提示添加内容
    return ;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OldUserLoginWihtWechat" object:nil];
     NSNumber *state = [notification object];
    if (state) {
        NSString *unionid = [WXUserInfo shareInstance].unionid;
        ////判断是不是真的是老用户，此微信号是否真的注册过！！
        if (unionid) {/////是老用户，退出登陆页面 isLogin YES
#warning  是老用户 从网获取用户信息 并保存本地 退出登陆页面
            
            [[UserInfoDao shareInstance] insertBean:[UserInfo shareInstance]];
            [[UserInfoDao shareInstance] selectUserInfoWithUserId:[UserInfo shareInstance].userId];/////重新获取到 [UserInfo shareInstance]主要是为了得到idKye
         
            [self dismissViewControllerAnimated:YES completion:^{
                [AppData shareInstance].isLogin = YES;
            }];
        } else {
            [[UITools shareInstance] showMessageToView:self.view message:@"请求出错" autoHide:YES];
        }
    }
}


#pragma mark - sender to WeChat
-(void)sendAuthRequest {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = [AppData random_uuid];
    [AppData shareInstance].wxRandomState = req.state;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.class isSubclassOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        //         NSLog(@"Home interactivePopGestureRecognizer");
        return YES;
    }
    return YES;
}

- (void)dealloc {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
