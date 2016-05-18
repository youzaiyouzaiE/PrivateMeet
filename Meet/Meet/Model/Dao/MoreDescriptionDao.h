//
//  MoreDescriptionDao.h
//  Meet
//
//  Created by jiahui on 16/5/18.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "SuperDao.h"

@interface MoreDescriptionDao : SuperDao


+ (instancetype)shareInstance;

- (NSArray *)selectMoreDescriptionByUserIDOrderByIndexASC:(NSString *)rserId;
- (NSArray *)selectMoreDescriptionByUserID:(NSString *)rserId ;

@end
