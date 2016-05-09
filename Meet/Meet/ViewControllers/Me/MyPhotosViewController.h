//
//  MyPhotosViewController.h
//  Meet
//
//  Created by jiahui on 16/4/30.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^needUpdateImagesContentBlock)(BOOL isNeed);

@interface MyPhotosViewController : UIViewController

@property (copy, nonatomic) needUpdateImagesContentBlock updateBlock;


@end
