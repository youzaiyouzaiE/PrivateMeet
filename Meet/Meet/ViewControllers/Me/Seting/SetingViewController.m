//
//  SetingViewController.m
//  Meet
//
//  Created by jiahui on 16/5/17.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "SetingViewController.h"
#import "UISheetView.h"
#import <MessageUI/MessageUI.h>
#import "AboutViewController.h"
#import "UserInfo.h"
#import "UserInfoDao.h"

@interface SetingViewController ()<UITableViewDelegate,UITableViewDataSource,UISheetViewDelegate,MFMailComposeViewControllerDelegate> {
//    NSArray *_contentArray;
    NSDictionary *_contentDic;
    UISheetView *_sheetView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backButtonAction:)];
    self.navigationItem.title = @"设置";
    
//    _contentArray = @[@"新消息通知",@"清除缓存",@"关于Meet",@"意见反馈",@"给Meet好评",@"退出登录"];
    _contentDic = @{@0:@[@"清除缓存"],@1:@[@"关于Meet",@"意见反馈",@"给Meet好评"],@2:@[@"退出登录"]};
    
    _tableView.rowHeight = 49;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _contentDic.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSNumber *keyNumber = [NSNumber numberWithInt:section];
    NSArray *arr = _contentDic[keyNumber];
    return  arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const defaultIdentifier = @"defaultIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultIdentifier];
    }
    NSNumber *keyNumber = [NSNumber numberWithInt:indexPath.section];
    NSArray *arr = _contentDic[keyNumber];
    cell.textLabel.text = arr[indexPath.row];
    if (indexPath.section == _contentDic.allKeys.count - 1) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *keyNumber = [NSNumber numberWithInt:indexPath.section];
    NSArray *arr = _contentDic[keyNumber];
    NSString *str = arr[indexPath.row];
    
    if (indexPath.section == _contentDic.allKeys.count - 1) {//////
        if ( !_sheetView) {
            _sheetView = [[UISheetView alloc] initWithContenArray:@[@"退出登录",@"取消"] titleMessage:@"退出后依然会保留当前用户信息"];
            _sheetView.delegate = self;
        }
        [_sheetView show];
    } else if ([str isEqualToString:@"关于Meet"]) {
        [self performSegueWithIdentifier:@"PushToAboutViewController" sender:self];
    } else if ([str isEqualToString:@"意见反馈"]) {
        if (![MFMailComposeViewController canSendMail]) {
            NSLog(@"Mail services are not available.");
            [[UITools shareInstance] showMessageToView:self.view message:@"请先设置邮箱帐号" autoHide:YES];
            return;
        }
        MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
        composeVC.mailComposeDelegate = self;
        // Configure the fields of the interface.、/////@"feedback@momeet.com"
        NSString *email = [UserInfo shareInstance].eMail;
        if (email != nil && email.length > 1) {
            [composeVC setToRecipients:@[email]];
        } else
            [composeVC setToRecipients:@[@"feedback@momeet.com"]];
        [composeVC setSubject:@"意见反馈"];
        [composeVC setMessageBody:@"test message " isHTML:NO];
        
        // Present the view controller modally.
        [self presentViewController:composeVC animated:YES completion:nil];
    }
}

#pragma mark - 
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    NSString *msg;
    
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            break;
        default:
            break;
    }
    [[UITools shareInstance] showMessageToView:controller.view message:msg autoHide:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    });
  
}

#pragma mark - UISheetViewDelegate
- (void)sheetView:(UISheetView *)sheet didSelectRowAtIndex:(NSInteger)index {
    if (index == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLogoutNotification" object:nil];
        [AppData shareInstance].isLogin = NO;
        [UserInfo shareInstance].loginType = [NSNumber numberWithInteger:0];
        [[UserInfoDao shareInstance] updateBean:[UserInfo shareInstance]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    [_sheetView hidden];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
