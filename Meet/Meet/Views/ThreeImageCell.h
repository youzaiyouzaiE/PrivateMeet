//
//  ThreeImageCell.h
//  Meet
//
//  Created by jiahui on 16/4/30.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeImageCell : UITableViewCell

@property (strong, nonatomic) UIImageView *fristImageView;
@property (strong, nonatomic) UIImageView *seconedImageView;
@property (strong, nonatomic) UIImageView *thirdImageView;

- (void)setViewsFrame;

+ (CGFloat)threeImageCellHeight;
- (void)defaultImageViewImages;

@end
