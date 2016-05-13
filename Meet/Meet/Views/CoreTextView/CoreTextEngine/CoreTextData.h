//
//  CoreTextData.h
//  Meet
//
//  Created by jiahui on 16/5/13.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface CoreTextData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSArray * imageArray;
@property (strong, nonatomic) NSArray * linkArray;
@property (strong, nonatomic) NSAttributedString *content;

@end
