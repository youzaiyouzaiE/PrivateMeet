//
//  HomeMainViewController.h
//  Meet
//
//  Created by jiahui on 16/4/28.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HomeContentViewType) {
    HomeContentViewTypeChoiceness = 0,
    HomeContentViewTypeCoffee,
    HomeContentViewTypeEat,
    HomeContentViewTypeMove,
    HomeContentViewTypeShow,
    HomeContentViewTypeTravel,
};

@interface HomeMainViewController : UIViewController//////第二版时可以用！！！=============

@property (assign, nonatomic) HomeContentViewType currentContentType;

@end
