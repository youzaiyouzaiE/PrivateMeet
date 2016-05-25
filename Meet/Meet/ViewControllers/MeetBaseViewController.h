//
//  MeetBaseViewController.h
//  Meet
//
//  Created by jiahui on 16/5/17.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

/////用于push  出的子 controller
@interface MeetBaseViewController : UIViewController<UINavigationControllerDelegate> /////子controller 左返回方法已经实现，侧滑返回事件实现


- (void)backButtonAction:(UIButton *)sender;

- (void)popGestureRecognizerDidAction;

@end
