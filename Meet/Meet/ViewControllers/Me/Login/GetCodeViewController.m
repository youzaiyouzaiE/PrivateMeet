//
//  GetCodeViewController.m
//  Meet
//
//  Created by jiahui on 16/5/6.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "GetCodeViewController.h"

@interface GetCodeViewController ()

@end

@implementation GetCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"获取邀请码";
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];
    [UITools navigationRightBarButtonForController:self action:@selector(cancelAction:) normalTitle:@"取消" selectedTitle:nil];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
