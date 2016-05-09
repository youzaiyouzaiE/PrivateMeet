//
//  AppDelegate.m
//  Meet
//
//  Created by jiahui on 16/4/28.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "WXApi.h"
#import "TalkingData.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "MBProgressHUD.h"
#import "AFNetWorking.h"
#import "NetWorkObject.h"

#import "UserInfo.h"
#import "WXAccessModel.h"
#import "WXUserInfo.h"

@interface AppDelegate ()<WXApiDelegate,NSURLConnectionDelegate> {
    NSURLConnection *_connection;
    NSURLConnection *_connectionLoadUserInfo;
    
    MBProgressHUD *loadingHUD;
}

@end

@implementation AppDelegate

static NSString *keyAccessModelSave = @"accessModelSaveKey";
static NSString *keyWXUserInfo = @"WeChatUserInfoKey";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Fabric with:@[[Crashlytics class]]];////////
    // TODO: Move this to where you establish a user session
    [self logUser];
    
    [WXApi registerApp:@"wx49c4b6f590f83469"];
    [TalkingData sessionStarted:@"7244A450FDAFB46FFEF7C1B68FBA93D3" withChannelId:@"app store"];
    
    NSDictionary *access_TokenDic = [[NSUserDefaults standardUserDefaults] objectForKey:keyAccessModelSave];
    NSDictionary *weChatUserInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:keyWXUserInfo];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[WXAccessModel shareInstance] initWithDictionary:access_TokenDic];
    [[WXUserInfo shareInstance] initWithDictionary:weChatUserInfoDic];
    
    return YES;
}

- (void) logUser {
    // TODO: Use the current user's information
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:@"12345"];
    [CrashlyticsKit setUserEmail:@"user@fabric.io"];
    [CrashlyticsKit setUserName:@"Test User"];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

-(MainViewController *)getRootViewController {
    MainViewController *rootVC = (MainViewController *) self.window.rootViewController;
    return rootVC;
}


#pragma mark - WXApiDelegate
-(void) onReq:(BaseReq*)req {
    
}

-(void) onResp:(BaseResp*)resp {
    if (resp.errCode != 0) {////确认
        return ;
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) {////登陆
        SendAuthResp *response = (SendAuthResp *)resp;
        if ([response.state isEqualToString:[AppData shareInstance].wxRandomState]) {
        NSString *code = response.code;
        NSDictionary *parameters = @{@"appid":[AppData shareInstance].wxAppID,@"secret":[AppData shareInstance].wxAppSecret,@"grant_type":@"authorization_code",@"code":code};
          loadingHUD = [[UITools shareInstance] showLoadingViewAddToView:self.window message:NSLocalizedString(@"loading", "加载中") autoHide:NO];
            [NetWorkObject GET:WX_access_tokenURL_str
                parameters:parameters
                  progress:^(NSProgress *downloadProgress) {
            }
                   success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                       WXAccessModel *model = [[WXAccessModel shareInstance] initWithDictionary:responseObject];
                       model.saveDate = [AppData curretnDate];
                       ////save
                       NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                       [dic setObject:model.saveDate forKey:@"saveDate"];
                       [[NSUserDefaults standardUserDefaults] setObject:dic forKey:keyAccessModelSave];
                       [self wechatLoginByRequestForUserInfo];
                       [loadingHUD hide:YES];
            }
                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                       [loadingHUD hide:YES];
                      
                NSLog(@"AF error :%@",error.localizedFailureReason);
            }];
        }
    }
}

- (void)wechatLoginByRequestForUserInfo {
    [NetWorkObject GET:GETUser_info_FromWX_URLStr parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *userInfo) {
        [[WXUserInfo shareInstance] initWithDictionary:userInfo];
        
        [[UITools shareInstance] showMessageToView:self.window message:@"登录成功" autoHide:YES];
         NSLog(@"请求微信用户信息成功！");
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:keyWXUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewUserLoginWihtWechat" object:[NSNumber numberWithInt:1]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OldUserLoginWihtWechat" object:[NSNumber numberWithInt:1]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [[UITools shareInstance] showMessageToView:self.window message:@"登录失败" autoHide:YES];
         NSLog(@"请求微信用户信息失败！");
         NSLog(@"error :%@",error.localizedFailureReason);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewUserLoginWihtWechat" object:[NSNumber numberWithInt:0]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OldUserLoginWihtWechat" object:[NSNumber numberWithInt:0]];
    }];
}

- (void)weChatRefreshAccess_Token {
    [NetWorkObject GET:WXRefresh_access_tokenURL_str([WXAccessModel shareInstance].refresh_token) parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        WXAccessModel *model = [[WXAccessModel shareInstance] initWithDictionary:responseObject];
        model.saveDate = [AppData curretnDate];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        [dic setObject:model.saveDate forKey:@"saveDate"];
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:keyAccessModelSave];
        NSLog(@"刷新Token成功！");
        [self wechatLoginByRequestForUserInfo];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"刷新Token失败！");
        NSLog(@"error :%@",error.localizedFailureReason);
    }];
}



@end
