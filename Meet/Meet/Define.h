//
//  Define.h
//  Meet
//
//  Created by jiahui on 16/4/28.
//  Copyright © 2016年 Meet. All rights reserved.
//

#ifndef Define_h
#define Define_h

#define SHARE_APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height//获取屏幕高度
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width//获取屏幕宽度

#define IOS_7LAST ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)?1:0
#define IOS_8LAST ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)?1:0

#define NAVIGATION_BAR_COLOR   [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.8]

#define WX_access_tokenURL_str          @"https://api.weixin.qq.com/sns/oauth2/access_token"
#define WX_refresh_tokenURL_str         @"https://api.weixin.qq.com/sns/oauth2/refresh_token"
#define WX_userInfo_URL_str             @"https://api.weixin.qq.com/sns/userinfo"

#define WXGET_access_tokenURL_str(code) [WX_access_tokenURL_str stringByAppendingFormat:@"?appid=%@&secret=%@&grant_type=authorization_code&code=%@",[AppData shareInstance].wxAppID,[AppData shareInstance].wxAppSecret,code]

#define WXRefresh_access_tokenURL_str(refresh_token)   [WX_refresh_tokenURL_str stringByAppendingFormat:@"?appid=%@&grant_type=refresh_token&refresh_token=%@",[AppData shareInstance].wxAppID,refresh_token]

#define GETUser_info_FromWX_URLStr [WX_userInfo_URL_str stringByAppendingFormat:@"?access_token=%@&openid=%@",[WXAccessModel shareInstance].access_token,[WXAccessModel shareInstance].openid]


#endif /* Define_h */
