//
//  ImageAndTitleView.h
//  Meet
//
//  Created by jiahui on 16/5/2.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAndTitleView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *labelRemind;
@property (strong, nonatomic) UILabel *lableTitle;

//////self size (74, 84)
- (void)loadSubViewFrames;
- (void)imageViewWithImage:(UIImage *)image labelTitleText:(NSString *)title andRemindText:(NSString *)remind;

@end
