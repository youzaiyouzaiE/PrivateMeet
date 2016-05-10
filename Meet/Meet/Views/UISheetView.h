//
//  UISheetView.h
//  Meet
//
//  Created by jiahui on 16/5/10.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UISheetView;
@protocol SheetViewSelectDelegate <NSObject>

- (void)sheetView:(UISheetView *)sheet didSelectRowAtIndex:(NSInteger)index;

@end

@interface UISheetView : UIView

@property (assign, nonatomic) id<SheetViewSelectDelegate> delegate;

- (instancetype)initWithContenArray:(NSArray *)array;

@end
