//
//  SendEmailViewController.m
//  Meet
//
//  Created by jiahui on 16/5/17.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "SendEmailViewController.h"
#import "UserInfo.h"


@interface SendEmailViewController () {
    
    __weak IBOutlet UITextField *_eMailTextfIeld;
    __weak IBOutlet UITextView *_textView;
    
}

@end

@implementation SendEmailViewController
- (void)loadView {
    [super loadView];
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backButtonAction:)];
    [UITools navigationRightBarButtonForController:self action:@selector(sendAction:) normalTitle:@"保存" selectedTitle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)sendAction:(id)sender {
    
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
