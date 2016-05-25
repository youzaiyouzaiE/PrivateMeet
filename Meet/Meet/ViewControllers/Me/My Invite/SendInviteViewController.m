//
//  SendInviteViewController.m
//  Meet
//
//  Created by jiahui on 16/5/14.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "SendInviteViewController.h"
#import "UITextView+Placeholder.h"

@interface SendInviteViewController () <UIScrollViewDelegate>{
    
    __weak IBOutlet UIScrollView *_contentScrollView;
    __weak IBOutlet UIScrollView *_topScrollView;
    __weak IBOutlet UILabel *_topLabel;
    
    __weak IBOutlet UIView *_selectItemView;
    __weak IBOutlet UITextView *_explainTextView;
    
    NSMutableArray *_arraySelectItem;
    
    BOOL _isLargeWidth;
    NSInteger _largeLength;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentScrollViewConstraintH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topScrollViewConstraintW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectItemViewConstraintH;

@end

@implementation SendInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的邀约";
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];
    [UITools navigationRightBarButtonForController:self action:@selector(doneAction:) normalTitle:@"完成" selectedTitle:nil];
    self.hidesBottomBarWhenPushed = YES;
    _arraySelectItem = [NSMutableArray array];
    [self loadButtonItemsWihtArray:@[@"吃饭",@"喝茶",@"喝咖啡",@"看电影",@"运动",@"周边游",@"公益活动",@"其它活动",@"这个名字很长很长很长"]];
    
    _explainTextView.placeholder = @"一段走心的活动说明，更有利于打动对方报名参加哦；\n 同时您也可以说说希望什么样的人参与您的活动。";
    _explainTextView.layer.cornerRadius = 3;
    _explainTextView.layer.borderWidth = 2;
    _explainTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
//    CGFloat itemViewW = _selectItemView.width;
     NSLog(@"itemView height,%f",_selectItemView.height);
}

#pragma mark - Items

#define ItemMargainW            7
#define ItemMargainH            10
#define ItemButtonH             25
#define ItemBottomMargain       5

- (void)loadButtonItemsWihtArray:(NSArray *)array {
    CGFloat itemViewW = ScreenWidth;
   __block  CGFloat xTotal = 8;
   __block  CGFloat yTotal = 8;
    __block NSInteger numberLinInteger = 0;
    [array enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        CGFloat buttonWidth  = [UITools getTextWidth:[UIFont systemFontOfSize:17] textContent:title] + 4;
        if (buttonWidth + xTotal + 8 > itemViewW ) {
            
            xTotal = 8;
            numberLinInteger = 0;
            yTotal += (ItemMargainH + ItemButtonH);
        }
         UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [titleButton setImageEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];  // make click area bigger
        [titleButton setTitle:title forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [titleButton setBackgroundImage:[UIImage imageNamed:@"ItemNomalImage"] forState:UIControlStateNormal];
        [titleButton setBackgroundImage:[UIImage imageNamed:@"ItemSelectedImage"] forState:UIControlStateNormal];
        titleButton.frame = CGRectMake(xTotal , yTotal, buttonWidth,ItemButtonH );
        [titleButton addTarget:self action:@selector(itemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectItemView addSubview:titleButton];
        xTotal += (buttonWidth + ItemMargainW);
        numberLinInteger ++;
    }];
    _selectItemViewConstraintH.constant = yTotal + ItemButtonH +ItemBottomMargain;
}

#pragma mark - action
- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneAction:(id)sender {
    
}

- (void)itemButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [_arraySelectItem addObject:button.currentTitle];
    } else
        [_arraySelectItem removeObject:button.currentTitle];
    
    [self updateTopViewContent];
}

- (void)updateTopViewContent {
    NSMutableString *contentStr = [NSMutableString stringWithString:@""];
    [_arraySelectItem enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        [contentStr appendString:[NSString stringWithFormat:@"%@、",title]];
    }];
    if (contentStr.length > 2) {
        [contentStr deleteCharactersInRange:NSMakeRange(contentStr.length - 1, 1)];
    }
    CGFloat stringWidth  = [UITools getTextWidth:[UIFont systemFontOfSize:17] textContent:contentStr] + 4;
    _topLabel.text = contentStr;
    _topLabel.font = [UIFont systemFontOfSize:17];
    
    if (stringWidth > _topScrollView.width) {
        _topScrollViewConstraintW.constant = stringWidth - 10 ;
//        _isLargeWidth = YES;
        _largeLength = stringWidth - _topScrollView.width;
         NSLog(@"Font.width :%f,%f",stringWidth,stringWidth - _topScrollView.width);
        [_topScrollView setContentOffset:CGPointMake(_largeLength , _topScrollView.contentOffset.y) animated:YES];
    } else {
//        _isLargeWidth = NO;
        _largeLength = 0;
        _topScrollViewConstraintW.constant = _topScrollView.width;
        [_topScrollView setContentOffset:CGPointMake(0, _topScrollView.contentOffset.y) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self updateTopScrollViewOffset];
//     NSLog(@"scrollView Offset %@",NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < _largeLength) {
//        if (_isLargeWidth) {
            [_topScrollView setContentOffset:CGPointMake(_largeLength , _topScrollView.contentOffset.y) animated:NO];
//        } else
//            [_topScrollView setContentOffset:CGPointMake(0, _topScrollView.contentOffset.y) animated:YES];
    }
    NSLog(@"scrollView Offset %@",NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
        [self.view endEditing:YES];
        return NO;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
     NSLog(@"%@",NSStringFromCGRect(textView.frame));
    [_contentScrollView setContentOffset:CGPointMake(_contentScrollView.x, textView.y - 150) animated:YES];
//    [_contentScrollView scrollsToTop];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if (textView.text.length >= 200 && text.length > range.length) {
//        return NO;
//    }
//    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
@end
