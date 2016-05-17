//
//  MeetBaseViewController.m
//  Meet
//
//  Created by jiahui on 16/5/17.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MeetBaseViewController.h"

@interface MeetBaseViewController ()

@end

@implementation MeetBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backButtonAction:)];
}

- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (![context isCancelled]) {
            [self popGestureRecognizerDidAction];
        }
    }];
}

- (void)popGestureRecognizerDidAction {
    NSLog(@"subClass do something");
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
