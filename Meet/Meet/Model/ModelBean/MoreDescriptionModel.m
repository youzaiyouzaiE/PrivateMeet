//
//  MoreDescriptionModel.m
//  Meet
//
//  Created by jiahui on 16/5/18.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MoreDescriptionModel.h"
#import "MoreDescriptionDao.h"

 NSString *const k_More_userId = @"More_userId";
 NSString *const k_More_title = @"More_title";
 NSString *const k_More_content = @"More_content";
 NSString *const k_More_index = @"More_index";
 NSString *const k_More_hasImage = @"More_hasImage";

@implementation MoreDescriptionModel

-(NSArray *)columnArray {
    return @[k_More_userId,k_More_title,k_More_content,k_More_index,k_More_hasImage];
}

- (NSArray *)valueArray {
    if (!_title) {
        _title = (NSString *)[NSNull null];
    }
    if (!_content) {
        _content = (NSString *)[NSNull null];
    }
    if (!_hasImage) {
        _hasImage = 0;
    }
    return @[_userId,_title,_content,[NSNumber numberWithInteger:_index],[NSNumber numberWithInteger:_hasImage]];
}

- (BOOL)deleteBean {
    return [[MoreDescriptionDao shareInstance] deleteBeanWithIdKey:self.idKey];
}

- (NSString *)description {
    return @"MoreDescriptionModel";
}


@end
