//
//  RemindImageCell.h
//  Meet
//
//  Created by jiahui on 16/5/2.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAndTitleView.h"

@interface RemindImageCell : UITableViewCell

@property (strong, nonatomic) ImageAndTitleView *fristItem;
@property (strong, nonatomic) ImageAndTitleView *secondItem;
@property (strong, nonatomic) ImageAndTitleView *thirdItem;
@property (strong, nonatomic) ImageAndTitleView *fourItem;

+ (CGFloat)remindImageCellHeight;

- (void)setSubViewsFrame;

- (void)addTapGestureRecognizers;

@end
