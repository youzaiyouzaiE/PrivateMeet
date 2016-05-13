//
//  CTFrameParserConfig.h
//  Meet
//
//  Created by jiahui on 16/5/13.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTFrameParserConfig : NSObject ////配置绘制参数

@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) CGFloat lineSpace;
@property (strong, nonatomic) UIColor *textColor;


@end
