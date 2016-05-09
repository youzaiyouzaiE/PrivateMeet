//
//  LoginMainViewController.m
//  Meet
//
//  Created by jiahui on 16/5/6.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "LoginMainViewController.h"

@interface LoginMainViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    
    __weak IBOutlet UIScrollView *scrollView;
}

@end

@implementation LoginMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.view endEditing:YES]) {
        [self.view endEditing:NO];
    }
    return NO;
}

- (IBAction)resgisterAction:(id)sender {
    
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
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
