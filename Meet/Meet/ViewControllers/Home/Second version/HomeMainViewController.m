//
//  HomeMainViewController.m
//  Meet
//
//  Created by jiahui on 16/4/28.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "HomeMainViewController.h"
#import "ChoicenessViewController.h"
#import "CoffeeViewController.h"
#import "EatViewController.h"
#import "MoveViewController.h"
#import "ShowViewController.h"
#import "TravelViewController.h"
#import "HomeMoreViewController.h"

//////第二版时可以用！！！===============
@interface HomeMainViewController () <UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    
    __weak IBOutlet UIView *titleView;
    __weak IBOutlet UIScrollView *titleScrollView;
    __weak IBOutlet UIView *disableView;
    __weak IBOutlet UIScrollView *contentScrollView;
    
    NSMutableArray *_titleArray;
    NSMutableArray *_contentClassArray;
    NSMutableArray *_buttonsArray;
    
    NSInteger _currentItem;
//    CGRect _frameMore;
}


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleScrollViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentScrollViewW;

@property (strong, nonatomic) HomeBaseViewController *currentVC;
@property (strong, nonatomic) ChoicenessViewController *choiceVC ;
@property (strong, nonatomic) CoffeeViewController *coffeeVC  ;
@property (strong, nonatomic) EatViewController *eatVC;
@property (strong, nonatomic) MoveViewController *moveVC;
@property (strong, nonatomic) ShowViewController *showVC;
@property (strong, nonatomic) TravelViewController *travelVC;
@property (strong, nonatomic) HomeMoreViewController *moreVC;

@property (assign, nonatomic) NSInteger numberTotleVCs;

@end

@implementation HomeMainViewController


#define BUTTON_W        80
#define BUTTON_H        38
#define BUTTON_MARGIN   4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleArray = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"Choiceness", @"精选"),@"喝咖啡",@"吃饭",@"电影",@"展览",@"旅行"]];
    _buttonsArray = [NSMutableArray array];
    _contentClassArray = [NSMutableArray arrayWithArray:@[@"ChoicenessViewController",@"ChoicenessViewController",@"EatViewController",@"MoveViewController",@"ShowViewController",@"TravelViewController"]];
    
    self.navigationItem.title =  NSLocalizedString(@"Home", @"homePag");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//        self.navigationController.navigationBar.barTintColor = NAVIGATION_BAR_COLOR;
    [UITools navigationRightBarButtonForController:self action:@selector(chooseItemAction:) normalTitle:NSLocalizedString(@"Choose","筛选") selectedTitle:nil];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (IOS_7LAST) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    [self loadTitleViewSubViews];
    
    _choiceVC = [[ChoicenessViewController alloc] init];
    [_choiceVC.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, contentScrollView.bounds.size.height)];
    [contentScrollView addSubview:_choiceVC.view];
    [self addChildViewController:_choiceVC];
    _currentVC = _choiceVC;
    _currentContentType = HomeContentViewTypeChoiceness;

    _moreVC = [[HomeMoreViewController alloc] init];
    _moreVC.view.frame = CGRectMake(0, contentScrollView.frame.origin.y, self.view.bounds.size.width, 0);
//    _frameMore = _moreVC.view.frame;
    [self.view addSubview:_moreVC.view];
    [self addChildViewController:_moreVC];
    
    disableView.hidden = YES;
    disableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)loadTitleViewSubViews {
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(titleBuutonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(i * (BUTTON_W +BUTTON_MARGIN), 1, BUTTON_W, BUTTON_H);
        button.tag = i;
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] + 3];
//            button.backgroundColor = [UIColor darkGrayColor];
        } else {
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
//            button.backgroundColor = [UIColor whiteColor];
        }
        [titleScrollView addSubview:button];
        [_buttonsArray addObject:button];
    }
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    _numberTotleVCs = 6;
    
    _titleScrollViewW.constant = _numberTotleVCs * (BUTTON_W + BUTTON_MARGIN) + 2*BUTTON_MARGIN;
    _contentScrollViewW.constant = self.view.bounds.size.width * _numberTotleVCs;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _contentClassArray = nil;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.class isSubclassOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        //         NSLog(@"Home interactivePopGestureRecognizer");
    }
    return YES;
}

#pragma mark - action 
- (void)chooseItemAction:(UIButton *)button  {
     NSLog(@"筛选");

}

- (void)titleBuutonAction:(UIButton *)button
{
    _currentItem = button.tag;
    _currentContentType = _currentItem;
    [self updateContentScrollView];
}

- (IBAction)moreButtonAction:(UIButton *)button {
    button.selected = !button.selected;
   
    CGFloat h = self.view.bounds.size.height;
    if (!button.selected) {
        h = 0;
        titleScrollView.userInteractionEnabled = YES;
    } else {
        titleScrollView.userInteractionEnabled = NO;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _moreVC.view.frame = CGRectMake(0, _moreVC.view.frame.origin.y, self.view.bounds.size.width, h);
        if (button.selected) {
            disableView.hidden = NO;
        } else
            disableView.hidden = YES;
    } completion:^(BOOL finished) {
      
    }];
}

#pragma mark - loadPageView 
- (void)loadContentViewContent {
    switch (_currentContentType) {
            
        case HomeContentViewTypeChoiceness:
            _currentVC = _choiceVC;
            break;
            
        case HomeContentViewTypeCoffee:
        {
            if (!_coffeeVC) {
                _coffeeVC = [[CoffeeViewController alloc] init];
                [_coffeeVC.view setFrame:CGRectMake(self.view.bounds.size.width * _currentContentType, 0, self.view.bounds.size.width, contentScrollView.bounds.size.height)];
                [contentScrollView addSubview:_coffeeVC.view];
                [self addChildViewController:_coffeeVC];
            }
            _currentVC = _coffeeVC;
        }
            break;
            
        case HomeContentViewTypeEat:
        {
            if (!_eatVC) {
                _eatVC = [[EatViewController alloc] init];
                [_eatVC.view setFrame:CGRectMake(self.view.bounds.size.width * _currentContentType, 0, self.view.bounds.size.width, contentScrollView.bounds.size.height)];
                [contentScrollView addSubview:_eatVC.view];
                [self addChildViewController:_eatVC];
            }
            _currentVC = _eatVC;
        }
            break;
            
        case HomeContentViewTypeMove:
        {
            if (!_moveVC) {
                _moveVC = [[MoveViewController alloc] init];
                [_moveVC.view setFrame:CGRectMake(self.view.bounds.size.width * _currentContentType, 0, self.view.bounds.size.width, contentScrollView.bounds.size.height)];
                [contentScrollView addSubview:_moveVC.view];
                [self addChildViewController:_moveVC];
            }
            _currentVC = _moveVC;
        }
            break;
            
        case HomeContentViewTypeShow:
        {
            if (!_showVC) {
                _showVC = [[ShowViewController alloc] init];
                [_showVC.view setFrame:CGRectMake(self.view.bounds.size.width * _currentContentType, 0, self.view.bounds.size.width, contentScrollView.bounds.size.height)];
                [contentScrollView addSubview:_showVC.view];
                [self addChildViewController:_showVC];
            }
            _currentVC = _showVC;
        }
            break;
            
        case HomeContentViewTypeTravel:
        {
            if (!_travelVC) {
                _travelVC = [[TravelViewController alloc] init];
                [_travelVC.view setFrame:CGRectMake(self.view.bounds.size.width * _currentContentType, 0, self.view.bounds.size.width, contentScrollView.bounds.size.height)];
                [contentScrollView addSubview:_travelVC.view];
                [self addChildViewController:_travelVC];
            }
            _currentVC = _travelVC;
        }
            break;
            
        default:
            break;
    }
}

- (void)updateTitleScrollView {
    if (titleScrollView.contentSize.width - _currentItem * (BUTTON_W +BUTTON_MARGIN) < titleScrollView.bounds.size.width ) {
        if (titleScrollView.contentOffset.x != titleScrollView.contentSize.width - titleScrollView.bounds.size.width) {
            [titleScrollView setContentOffset:CGPointMake(titleScrollView.contentSize.width - titleScrollView.bounds.size.width, 0) animated:YES];
        }
    } else {
        [titleScrollView setContentOffset:CGPointMake(_currentItem * (BUTTON_W +BUTTON_MARGIN), 0) animated:YES];
    }
    [self modifyTitleButtonFont];
}

- (void)modifyTitleButtonFont {
    [_buttonsArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * stop) {
        if (_currentItem == idx) {
            button.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] + 3];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else {
            button.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }];
}

- (void)updateContentScrollView {
    [contentScrollView setContentOffset:CGPointMake(_currentItem * contentScrollView.bounds.size.width, 0) animated:YES];
    [self loadContentViewContent];
    [self updateTitleScrollView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {///减速
    if (scrollView == contentScrollView) {
        _currentContentType = scrollView.contentOffset.x /scrollView.bounds.size.width;
        _currentItem = scrollView.contentOffset.x /scrollView.bounds.size.width;
        [self loadContentViewContent];
        [self updateTitleScrollView];
    }
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
