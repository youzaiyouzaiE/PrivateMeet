//
//  MoreDescriptionModel.h
//  Meet
//
//  Created by jiahui on 16/5/18.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "BaseModel.h"

extern NSString *const k_More_userId ;
extern NSString *const k_More_title ;
extern NSString *const k_More_content;
extern NSString *const k_More_index;
extern NSString *const k_More_hasImage;

@interface MoreDescriptionModel : BaseModel

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
/////等于model所在的section
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger hasImage;



@end
