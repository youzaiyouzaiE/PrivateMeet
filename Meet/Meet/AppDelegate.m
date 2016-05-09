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
#import "UserInfo.h"
#import "WXAccessModel.h"
#import "WXUserInfo.h"
#import "TalkingData.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "MBProgressHUD.h"
#import "AFNetWorking.h"
#import "NetWorkObject.h"


@interface AppDelegate ()<WXApiDelegate,NSURLConnectionDelegate> {
    NSURLConnection *_connection;
    NSURLConnection *_connectionLoadUserInfo;
    
    MBProgressHUD *loadingHUD;
}

@end

@implementation AppDelegate

static NSString * keyAccessModelSave = @"accessModelSaveKey";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Fabric with:@[[Crashlytics class]]];////////
    // TODO: Move this to where you establish a user session
    [self logUser];
    
    [WXApi registerApp:@"wx49c4b6f590f83469"];
//    [TalkingData sessionStarted:@"7D6CE6D445B00CD68BBF924B301E789F" withChannelId:@"app store"];
    
    NSDictionary *responseObject = [[NSUserDefaults standardUserDefaults] objectForKey:keyAccessModelSave];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
   [[WXAccessModel shareInstance] initWithDictionary:responseObject];
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
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req {
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp {
    if (resp.errCode != 0) {////确认
        return ;
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) {////登陆
        SendAuthResp *response = (SendAuthResp *)resp;
        if ([response.state isEqualToString:[AppData shareInstance].wxRandomState]) {
        NSString *code = response.code;
        NSDictionary *rpameters = @{@"appid":[AppData shareInstance].wxAppID,@"secret":[AppData shareInstance].wxAppSecret,@"grant_type":@"authorization_code",@"code":code};
        [NetWorkObject GET:WX_access_tokenURL_str
                parameters:rpameters
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
            }
                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"AF error :%@",error.localizedFailureReason);
            }];
        }
    }
}

- (void)wechatLoginByRequestForUserInfo {
    [NetWorkObject GET:GETUser_info_FromWX_URLStr parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *userInfo) {
        [[WXUserInfo shareInstance] initWithDictionary:userInfo];
         NSLog(@"请求微信用户信息成功！");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"请求微信用户信息失败！");
         NSLog(@"error :%@",error.localizedFailureReason);
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
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"刷新Token失败！");
        NSLog(@"error :%@",error.localizedFailureReason);
    }];
}



@end
