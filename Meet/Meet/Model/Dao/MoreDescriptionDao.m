//
//  MoreDescriptionDao.m
//  Meet
//
//  Created by jiahui on 16/5/18.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MoreDescriptionDao.h"
#import "MoreDescriptionModel.h"

@implementation MoreDescriptionDao

static NSString *const tableName = @"MoreDescriptionTable";

+ (instancetype)shareInstance {
    static MoreDescriptionDao *shareInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[MoreDescriptionDao  alloc] init];
    });
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self greateTable];
    }
    return self;
}

- (void)greateTable {
    FMResultSet *set = [self.db executeQuery:[NSString stringWithFormat:@"select count (*) from sqlite_master where type = 'table' and name = '%@'",tableName]];
    [set next];
    if ([set intForColumnIndex:0]) {
        //        NSLog(@"表已经存！");
    } else {
        NSString *sql = [NSString stringWithFormat:@"create table IF NOT EXISTS %@ ('%@' text,'%@' text,'%@' text,'%@' text,'%@' integer,'%@' integer)",tableName,kBeanIdKey,k_More_userId,k_More_title,k_More_content,k_More_index,k_More_hasImage];
        if ([self.db executeUpdate:sql]) {
            NSLog(@"表创建成功！");
        } else {
            NSLog(@"表创建失败！");
        }
    }
}

- (id)mappingRs2Bean:(FMResultSet *)rs {
    MoreDescriptionModel *model = [[MoreDescriptionModel alloc] init];
    model.idKey = [rs stringForColumn:kBeanIdKey];
    model.userId = [rs stringForColumn:k_More_userId];
    model.title = [rs stringForColumn:k_More_title];
    model.content = [rs stringForColumn:k_More_content];
    model.index = [rs intForColumn:k_More_index];
    model.hasImage = [rs intForColumn:k_More_hasImage];
    return model;
}

- (NSString *)tableName {
    return tableName;
}

- (NSArray *)selectMoreDescriptionByUserIDOrderByIndexASC:(NSString *)rserId {
    NSString *whereSql = [NSString stringWithFormat:@"%@ = '%@'", k_More_userId,rserId];
    return [self selectWithWhere:whereSql order:[NSString stringWithFormat:@"%@ ASC",k_More_index]];
}

- (NSArray *)selectMoreDescriptionByUserID:(NSString *)rserId {
    NSString *whereSql = [NSString stringWithFormat:@"%@ = '%@'", k_More_userId,rserId];
    return [self selectWithWhere:whereSql];
}

- (MoreDescriptionModel *)selectMoreDescriptionByUserID:(NSString *)rserId andIndex:(NSInteger)index {
    NSString *whereSql = [NSString stringWithFormat:@"%@ = '%@' AND %@ = %d", k_More_userId,rserId,k_More_index,index];
    NSArray *array = [self selectWithWhere:whereSql];
    if (array.count >0) {
        return array[0];
    } else
        return nil;
}

- (NSString *)description {
    return @"BigCategoryDao";
}

@end
