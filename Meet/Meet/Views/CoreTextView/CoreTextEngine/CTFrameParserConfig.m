
//
//  CTFrameParserConfig.m
//  Meet
//
//  Created by jiahui on 16/5/13.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _width = ScreenWidth - 10 -10;
        _fontSize = 16.0f;
        _lineSpace = 5.0f;
        _textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    }
    return self;
}


@end
