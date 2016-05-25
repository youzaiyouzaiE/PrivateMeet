//
//  AboutViewController.m
//  Meet
//
//  Created by jiahui on 16/5/17.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "AboutViewController.h"
#import "MeetBaseViewController.h"
#import "UserProtocolViewController.h"

@interface AboutViewController () {
    
    __weak IBOutlet UIImageView *_logoImageView;
    __weak IBOutlet UILabel *_labelLogoBottom;
    
    UserProtocolViewController *_userProtocolVC;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于Meet";
    _logoImageView.layer.cornerRadius = 5;
    _logoImageView.layer.masksToBounds = YES;
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action
- (IBAction)serverButtonAction:(UIButton *)button {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",button.currentTitle];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (IBAction)useProtocolAction:(UIButton *)sender {
    if (_userProtocolVC) {
        [self.navigationController pushViewController:_userProtocolVC animated:YES];
    } else {
        [self performSegueWithIdentifier:@"PushToUserProtocolViewController" sender:self];
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PushToUserProtocolViewController"]) {
        _userProtocolVC = (UserProtocolViewController *)segue.destinationViewController;
    }
}


@end
