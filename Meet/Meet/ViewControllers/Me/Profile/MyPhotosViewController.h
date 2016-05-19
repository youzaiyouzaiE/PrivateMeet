//
//  MyPhotosViewController.h
//  Meet
//
//  Created by jiahui on 16/4/30.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NeedUpdateImagesContentBlock)(BOOL isModify);

@interface MyPhotosViewController : UIViewController


@property (nonatomic, assign) BOOL useOtherPath;
@property (strong, nonatomic) NSIndexPath *selectIndexPath;
@property (assign, nonatomic) NSInteger maxIamges;
@property (copy, nonatomic) NeedUpdateImagesContentBlock updateBlock;


@end
