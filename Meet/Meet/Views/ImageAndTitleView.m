//
//  ImageAndTitleView.m
//  Meet
//
//  Created by jiahui on 16/5/2.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "ImageAndTitleView.h"

//////self size (74, 84)

@implementation ImageAndTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadSubViews];
    }
    return self;
}



- (void)loadSubViews {
    _imageView = [[UIImageView alloc] init];
    
    _labelRemind = [[UILabel alloc] init];
    _labelRemind.textColor = [UIColor redColor];
    _labelRemind.textAlignment = NSTextAlignmentLeft;
    
    _lableTitle = [[UILabel alloc] init];
    _lableTitle.textAlignment = NSTextAlignmentCenter;
    
    _labelRemind .hidden = YES;
    [self addSubview:_imageView];
    [self addSubview:_labelRemind];
    [self addSubview:_lableTitle];
}

- (void)loadSubViewFrames {
    _imageView.frame = CGRectMake((self.bounds.size.width - 44)/2 , 8, 44, 44);
    
//    _labelRemind.frame = CGRectMake(44, 0, 26, 21);
    
    _lableTitle.frame = CGRectMake(0, 60, 74, 21);
}

- (void)imageViewWithImage:(UIImage *)image labelTitleText:(NSString *)title andRemindText:(NSString *)remind {
    _imageView.image = image;
    _lableTitle.text = title;
    if (remind != nil) {
        _labelRemind.hidden = NO;
        _labelRemind.text = remind;
        CGFloat textWidth = [UITools getTextWidth:[UIFont systemFontOfSize:[UIFont systemFontSize]] textContent:remind];
        _labelRemind.frame = CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width - 4, 0, textWidth, 21);
        
    } else {
       _labelRemind.hidden = YES;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
