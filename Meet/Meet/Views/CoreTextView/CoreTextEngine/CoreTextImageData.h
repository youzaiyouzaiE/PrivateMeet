//
//  CoreTextImageData.h
//  Meet
//
//  Created by jiahui on 16/5/13.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextImageData : NSObject

@property (strong, nonatomic) NSString * name;
@property (nonatomic) int position;

// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;

@end
