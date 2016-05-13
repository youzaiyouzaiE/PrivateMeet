//
//  MoreProfileViewController.h
//  Meet
//
//  Created by jiahui on 16/5/4.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^modifyImagesBlock)(void);

@interface MoreProfileViewController : UIViewController


@property (assign, nonatomic) NSInteger editType;////是编辑页面（1，为编辑（从MeVC图片cell push进入的），0 为个人信息弹入的）

@property (assign, nonatomic) modifyImagesBlock modifyBlock;

@end
