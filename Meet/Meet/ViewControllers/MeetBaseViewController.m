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

////server barnch moidfy AAAA

////server barnch moidfy BBBB

////server barnch moidfy CCCCc

////server barnch moidfy 1111


////server barnch moidfy 2222




- (void)dealloc
{
     NSLog(@"%@ -> %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}

@end
