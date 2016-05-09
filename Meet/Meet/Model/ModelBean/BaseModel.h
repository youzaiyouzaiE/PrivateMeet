//
//  BaseModel.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kBeanIdKey;

@interface BaseModel : NSObject <NSCoding>

///use for DB
@property (copy, nonatomic, readonly) NSArray *columnArray;
@property (strong, nonatomic, readonly) NSArray *valueArray;
@property (copy, nonatomic) NSString *idKey;


- (instancetype)initWithDictionary:(NSDictionary *)dict;

-(BOOL)deleteBean;

@end
