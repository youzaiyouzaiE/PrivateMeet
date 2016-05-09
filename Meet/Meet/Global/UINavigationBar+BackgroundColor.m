//
//  UINavigationBar+BackgroundColor.m
//  NavigationBarColorTest
//
//  Created by jiahui on 15/12/31.
//  Copyright © 2015年 YouZai. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import <objc/runtime.h>

@implementation UINavigationBar (BackgroundColor)
static char overlayKey;

///由于category 不能添加属性，所以此为利用OC的runtime 动态添加一假的属性。只是实现了overlay 的set 与get方法
- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
    
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor {
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        // insert an overlay into the view hierarchy
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height + 20)];
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

@end
