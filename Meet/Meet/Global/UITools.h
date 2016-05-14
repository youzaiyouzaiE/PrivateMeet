//
//  UITools.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/19.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface UITools : NSObject


+(instancetype)shareInstance ;


+ (void)customNavigationBackButtonAndTitle:(NSString *)title forController:(UIViewController *)controller;

+ (void)customNavigationLeftBarButtonForController:(UIViewController *)controller action:(SEL)select;
- (void)customNavigationLeftBarButtonForController:(UIViewController *)controller;/////has pop method in self from appdelegate

+ (void)navigationRightBarButtonForController:(UIViewController *)controller action:(SEL)select normalTitle:(NSString *)normal selectedTitle:(NSString *)selected;
+ (void)navigationRightBarButtonForController:(UIViewController *)controller action:(SEL)select normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage;

//- (void)showMessageToView:(UIView *)view message:(NSString *)message;
- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide;
- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHideTime:(NSTimeInterval )interval ;
- (MBProgressHUD *)showLoadingViewAddToView:(UIView *)view autoHide:(BOOL)autoHide;
- (MBProgressHUD *)showLoadingViewAddToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide;

+ (float)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt;
+ (CGFloat)getTextWidth:(UIFont *)font textContent :(NSString *)text;
+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
