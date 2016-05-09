//
//  MyPhotoItem.m
//  Meet
//
//  Created by jiahui on 16/4/30.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MyPhotoItem.h"

@implementation MyPhotoItem

- (void)awakeFromNib {
//     NSLog(@"awakeFromNib");
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(photoItemButtonAction:)]) {
        [_delegate photoItemButtonAction:_index];
    }
}




@end
