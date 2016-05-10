//
//  WeChatLonginViewController.m
//  Meet
//
//  Created by jiahui on 16/5/6.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "WeChatLonginViewController.h"
#import "MyProfileViewController.h"
#import "WXApi.h"

#import "WXApiObject.h"
//#import "NSUserDefaults+RMSaveCustomObject.h"
#import "UserInfoDao.h"
#import <objc/runtime.h>

@interface WeChatLonginViewController ()

@property (assign, nonatomic) BOOL isNewUser;

@end

@implementation WeChatLonginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];
    [UITools navigationRightBarButtonForController:self action:@selector(cancelAction:) normalTitle:@"取消" selectedTitle:nil];
    
    _isNewUser = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)loginButtonAction:(id)sender {
    if (_isNewUser) {
    [self sendAuthRequest];
//////判断是否真实存在用户
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginState:) name:@"NewUserLoginWihtWechat" object:nil];
//        loading View start
    }
}

#pragma mark - notification 
- (void)loginState:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewUserLoginWihtWechat" object:nil];
    NSNumber *state = [notification object];
    if (state.intValue) {
        [[UserInfo shareInstance] mappingValuesFormWXUserInfo:[WXUserInfo shareInstance]];
        NSDictionary *dic = [[UserInfo shareInstance] dictionaryWithUserInfo];
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:keyUserInfo];
        
        UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
        MyProfileViewController *myProfileVC = [meStoryBoard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
        myProfileVC.isFristLogin = YES;
        [self.navigationController pushViewController:myProfileVC animated:YES];
    }
}

//- (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj {
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    
//    unsigned count;
//    objc_property_t *properties = class_copyPropertyList([obj class], &count);
//    
//    for (int i = 0; i < count; i++) {
//        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
//        [dict setObject:[obj valueForKey:key] forKey:key];
//    }
//    
//    free(properties);
//    
//    return [NSDictionary dictionaryWithDictionary:dict];
//}


#pragma mark - sender to WeChat
-(void)sendAuthRequest {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = [AppData random_uuid];
    [AppData shareInstance].wxRandomState = req.state;
    //第三方向微信终端发送一个SendAuthReq消息结构
    if (![WXApi sendReq:req]) {
        [[UITools shareInstance] showMessageToView:self.view message:@"请安装WeChart" autoHide:YES];
         NSLog(@"未安装WeChart");
    };
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
