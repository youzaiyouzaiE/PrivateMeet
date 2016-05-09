//
//  WeChatResgisterViewController.m
//  Meet
//
//  Created by jiahui on 16/5/6.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "WeChatResgisterViewController.h"
#import "WeChatLonginViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXAccessModel.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface WeChatResgisterViewController ()<UIGestureRecognizerDelegate>

@end

@implementation WeChatResgisterViewController

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
    [self performSegueWithIdentifier:@"pushToWeChatLogin" sender:self];
    
    if([WXAccessModel shareInstance].isLostAccess_token) {
         NSLog(@"lost Access_token");
    } else {
        [SHARE_APPDELEGATE wechatLoginByRequestForUserInfo];
    }
    
    if([WXAccessModel shareInstance].isLostRefresh_token) {
        NSLog(@"lost Refresh Access_token");
    }
}

- (IBAction)useWeChatLogin:(id)sender {
    [self sendAuthRequest];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
