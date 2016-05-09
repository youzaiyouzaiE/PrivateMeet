//
//  BaseModel.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "BaseModel.h"

NSString *const kBeanIdKey = @"idKey";

@implementation BaseModel


- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
     NSLog(@"undefined Key:%@", key);
}


#pragma  amrk - need subClass added method
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder { // NS_DESIGNATED_INITIALIZER
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}


#pragma mark - DB use
- (NSArray *)columnArray {
    NSAssert(NO, @"SubClass: columnString");
    return nil;
}

- (NSArray *)valueArray {
    NSAssert(NO, @"SubClass: valueArray");
    return nil;
}

- (BOOL)deleteBean {
    NSLog(@"the method not implement");
    return NO;
}

@end
