//
//  MyDisplayViewController.m
//  Meet
//
//  Created by jiahui on 16/5/13.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MyDisplayViewController.h"
#import "CTTextView.h"
#import "MoreProfileViewController.h"

@implementation MyDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人介绍";
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];
    [UITools navigationRightBarButtonForController:self action:@selector(editAction:) normalTitle:@"编辑" selectedTitle:nil];
    
}

#pragma mark - action
- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction:(id)sender {
    ///填写更多个人信息
    UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
    MoreProfileViewController *moreVC = [meStoryBoard instantiateViewControllerWithIdentifier:@"MoreProfileViewController"];
    moreVC.modifyBlock = ^(){
        
    };
    moreVC.editType = 1;
    [self.navigationController pushViewController:moreVC animated:YES];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToMyDisplayVC"]) {
        
    }
}

@end
