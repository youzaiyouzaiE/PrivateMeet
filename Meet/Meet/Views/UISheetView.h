//
//  UISheetView.h
//  Meet
//
//  Created by jiahui on 16/5/10.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UISheetView;
@protocol UISheetViewDelegate <NSObject>

- (void)sheetView:(UISheetView *)sheet didSelectRowAtIndex:(NSInteger)index;

@end

@interface UISheetView : UIView

@property (assign, nonatomic) BOOL isShow;
@property (assign, nonatomic) id<UISheetViewDelegate> delegate;

- (instancetype)initWithContenArray:(NSArray *)array;

- (void)show;

- (void)hidden;

@end
