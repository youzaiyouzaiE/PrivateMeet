//
//  MeetBaseViewController.h
//  Meet
//
//  Created by jiahui on 16/5/17.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetBaseViewController : UIViewController<UINavigationControllerDelegate>


- (void)backButtonAction:(UIButton *)sender;

- (void)popGestureRecognizerDidAction;

@end
