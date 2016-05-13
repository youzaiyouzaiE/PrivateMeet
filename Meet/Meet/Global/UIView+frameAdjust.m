//
//  UIView+frameAdjust.m
//  Meet
//
//  Created by jiahui on 16/5/13.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "UIView+frameAdjust.h"

@implementation UIView (frameAdjust)


- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.w, self.h);
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.w, self.h);
}
  
- (CGFloat)w {
    return self.frame.size.width;
}

- (void)setW:(CGFloat)w {
    self.frame = CGRectMake(self.x, self.y, w, self.h);
}

- (CGFloat)h {
    return self.frame.size.height;
}

- (void)setH:(CGFloat)h {
    self.frame = CGRectMake(self.x, self.y, self.w, h);
}

@end
