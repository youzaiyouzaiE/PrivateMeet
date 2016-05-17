//
//  MyMeetsViewController.m
//  Meet
//
//  Created by jiahui on 16/5/14.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MyMeetsViewController.h"
#import "BaseMeetViewController.h"
#import "AllMeetViewController.h"
#import "WillAllowViewColler.h"
#import "WillMeetViewColler.h"

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

@property (strong, nonatomic) NSMutableArray *arraySubViewControllers;


@end

@implementation MyMeetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title =  @"订单中心";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = NAVIGATION_BAR_COLOR;

    _arraySubViewControllers = [NSMutableArray array];
    _topBgLabel.layer.cornerRadius = (_topBgLabel.height/2);
    _topBgLabel.layer.masksToBounds = YES;
    [self getSelectButtonWithIndex:1];
    _currentType = 1;
    
    [self getSubControllerWithControllerClassName:@"WillAllowViewColler" atLocation:1];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    _scrollViewConstraintW.constant = _arrayButtons.count * self.view.width;
    _contentScrollView.contentOffset = CGPointMake(self.view.width, _contentScrollView.contentOffset.y);
//    _topBgLabelConstraintX.constant = _selectedButton.x;
    //    _contentScrollViewOffsetX = self.view.width;
}

#pragma -  VIEWs
- (void)getSelectButtonWithIndex:(NSInteger)index {
    [_arrayButtons enumerateObjectsUsingBlock:^(UIButton *_button, NSUInteger idx, BOOL *stop) {
        if (_button.tag == index +1) {
            _selectedButton = _button;
            *stop = YES;
        }
    }];
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

- (void)loadContentViewSubViewWithSelectType:(NSInteger)selectType {
    switch (selectType) {
        case 0:
        {
            BOOL hasTheVC = NO;
            for (BaseMeetViewController *meetVC in _arraySubViewControllers) {
                if ([meetVC isKindOfClass:[AllMeetViewController class]]) {
                    hasTheVC = YES;
                    return ;
                }
            }
            NSString *subClassName = @"AllMeetViewController";
            if (!hasTheVC) {
                [self getSubControllerWithControllerClassName:subClassName atLocation:selectType];
            }
        }
            break;
        case 1:
        {
         ////already has WillAllowViewColler
        }
            break;
        case 2:
        {
            BOOL hasTheVC = NO;
            for (BaseMeetViewController *meetVC in _arraySubViewControllers) {
                if ([meetVC isKindOfClass:[WillMeetViewColler class]]) {
                    hasTheVC = YES;
                    return ;
                }
            }
            NSString *subClassName = @"WillMeetViewColler";
            if (!hasTheVC) {
                [self getSubControllerWithControllerClassName:subClassName atLocation:selectType];
            }
        }
            break;
        default:
            break;
    }
}

- (BaseMeetViewController *)getSubControllerWithControllerClassName:(NSString *)className atLocation:(NSInteger)location{
    Class class = NSClassFromString(className);
    BaseMeetViewController *subVC = [[class alloc] init];
    [subVC.view setFrame:CGRectMake(location *self.view.width, 0, self.view.width, _contentScrollView.height)];
    [_contentScrollView addSubview:subVC.view];
    [self addChildViewController:subVC];
    [_arraySubViewControllers addObject:subVC];
    return subVC;
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
            [self loadContentViewSubViewWithSelectType:_currentType];
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
    [self loadContentViewSubViewWithSelectType:_currentType];
}

#pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     
 }

@end
