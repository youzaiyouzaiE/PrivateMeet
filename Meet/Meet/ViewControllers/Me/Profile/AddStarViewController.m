//
//  AddStarViewController.m
//  Meet
//
//  Created by jiahui on 16/5/5.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "AddStarViewController.h"
#import "UITextView+Placeholder.h"
//#import "UIPlaceHolderTextView.h"

@interface AddStarViewController ()<UIGestureRecognizerDelegate,UITextViewDelegate>

@property (strong, nonatomic) UITextView *textView;

@end

@implementation AddStarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"描述个人亮点";
    [self customNavigationBar];
    [UITools navigationRightBarButtonForController:self action:@selector(saveAction:) normalTitle:@"保存" selectedTitle:nil];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(3, 0, self.view.bounds.size.width - 6, self.view.bounds.size.height)];
    _textView.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _textView.placeholder = @"添更多亮点，更有利于别人搜索到你";

    
    [self.view addSubview:_textView];
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customNavigationBar {
    UIButton *cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut setFrame:CGRectMake(0, 0, 40, 40)];
    [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBut addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBut];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
}

#pragma mark - Action
- (void)cancelButtonAction:(id)sender {
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)saveAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -  UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    [self.textView resignFirstResponder];
    return NO;
}

#pragma mark -  UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
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
