//
//  SuperDao.h
//  Meet
//
//  Created by jiahui on 16/5/9.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "FMDatabase.h"
@interface SuperDao : NSObject

@property (copy, nonatomic, readonly) NSString *tableName;
@property (strong, nonatomic) FMDatabase *db;

- (int)selectCount;

- (int)selectMaxValue:(NSString *)column;

- (NSArray *)selectAll;
- (NSArray *)selectWithWhere:(NSString *)whereSql;
- (NSArray *)selectWithOrder:(NSString *)orderSql;
- (NSArray *)selectWithWhere:(NSString *)whereSql order:(NSString *)orderSql;
- (NSArray *)selectWithWhere:(NSString *)whereSql limitScalar:(NSInteger)scalar andStart:(NSInteger)start;

- (BOOL)insertBean:(BaseModel *)bean;
- (void)deleteAll;
- (void)deleteWithWhere:(NSString *)whereSql;
- (BOOL)deleteBeanWithIdKey:(NSString *)idKey;
- (BOOL)updateBean:(BaseModel *)bean;


@end
