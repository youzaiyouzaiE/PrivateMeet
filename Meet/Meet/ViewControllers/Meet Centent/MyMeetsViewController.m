//
//  MyMeetsViewController.m
//  Meet
//
//  Created by jiahui on 16/5/14.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MyMeetsViewController.h"
#import "WillMeetViewColler.h"
#import "AllMeetViewController.h"
#import "WillAllowViewColler.h"

@interface MyMeetsViewController ()<UIScrollViewDelegate> {
    
    __weak IBOutlet UILabel *_topBgLabel;
    __weak IBOutlet UIScrollView *_contentScrollView;
    UIButton *_selectedButton;
    
//    CGFloat _contentScrollViewOffsetX;
    
}

@property (assign, nonatomic) NSInteger currentType;///0 所有 ；1 待确认 ；2待见面

@property (strong, nonatomic) IBOutletCollection (UIButton) NSArray *arrayButtons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBgLabelConstraintX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewConstraintW;

@end

@implementation MyMeetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title =  @"订单中心";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = NAVIGATION_BAR_COLOR;
    
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //    [self setNeedsStatusBarAppearanceUpdate];
    _topBgLabel.layer.cornerRadius = (_topBgLabel.height/2);
    _topBgLabel.layer.masksToBounds = YES;
    [self getSelectButtonWithIndex:1];
}

- (void)getSelectButtonWithIndex:(NSInteger)index {
    [_arrayButtons enumerateObjectsUsingBlock:^(UIButton *_button, NSUInteger idx, BOOL *stop) {
        if (_button.tag == index +1) {
            _selectedButton = _button;
            NSLog(@"%@",_selectedButton.currentTitle);
            *stop = YES;
        }
    }];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    _scrollViewConstraintW.constant = _arrayButtons.count * self.view.width;
    _contentScrollView.contentOffset = CGPointMake(self.view.width, _contentScrollView.contentOffset.y);
//    _contentScrollViewOffsetX = self.view.width;
}

- (void)updateTopViewLabel{
    [UIView animateWithDuration:0.3f animations:^{
        _topBgLabel.frame = CGRectMake(_selectedButton.x, _topBgLabel.y, _topBgLabel.width, _topBgLabel.height);
    }];
}


- (void)updateButtonTitle:(UIButton *)button {
    [_arrayButtons enumerateObjectsUsingBlock:^(UIButton *_button, NSUInteger idx, BOOL *stop) {
        if (_button == button) {
            [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }];
}

#pragma mark - buttonAction 
- (IBAction)topButtonsAction:(UIButton *)button  {
    if (button == _selectedButton) {
        return ;
    }
    [_arrayButtons enumerateObjectsUsingBlock:^(UIButton *_button, NSUInteger idx, BOOL *stop) {
        if (_button == button) {
            _selectedButton = _button;
            _currentType = idx;
            [self updateButtonTitle:_button];
            [self updateTopViewLabel];
            [self updateContentScrollView];
            *stop = YES;
        }
    }];
}


- (void)updateContentScrollView {
     [_contentScrollView setContentOffset:CGPointMake(_currentType * _contentScrollView.bounds.size.width, 0) animated:YES];
//    _contentScrollViewOffsetX = _currentType * _contentScrollView.bounds.size.width;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat scale = 100/self.view.width;
//    CGFloat space = scrollView.contentOffset.x - _contentScrollViewOffsetX;
//    CGFloat frameValue = scale *space;
//    [self modifyTopBgLabelFrame:frameValue];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger seletType = scrollView.contentOffset.x /scrollView.bounds.size.width;
    if (seletType == _currentType) {
        return ;
    }
    _currentType = seletType;
    [self getSelectButtonWithIndex:_currentType];
    [self updateButtonTitle:_selectedButton];
    [self updateTopViewLabel];
//     _contentScrollViewOffsetX = scrollView.contentOffset.x;
}

#pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     
 }

@end
