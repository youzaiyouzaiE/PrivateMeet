//
//  MyDisplayViewController.h
//  Meet
//
//  Created by jiahui on 16/5/13.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NeedUpdateSectondImages)(void);

@interface MyDisplayViewController : UIViewController
@property (copy, nonatomic) NeedUpdateSectondImages block;

@end
