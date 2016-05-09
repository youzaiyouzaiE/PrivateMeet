//
//  AppData.h
//  EasyBusiness
//
//  Created by jiahui on 15/10/13.
//  Copyright (c) 2015年 YouZai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface AppData : NSObject

@property (strong, nonatomic) FMDatabase *db;
@property (assign, nonatomic) BOOL isLogin;

@property (copy, nonatomic) NSString *wxAppID;
@property (copy, nonatomic) NSString *wxAppSecret;
@property (copy, nonatomic) NSString *wxRandomState;
@property (copy, nonatomic) NSString *wxAccess_token;


+ (instancetype) shareInstance;
- (BOOL)initDataBaseToDocument;

+ (NSString *)random_uuid;
+ (NSString *)getCachesDirectoryDocumentPath:(NSString *)documentName;
+ (NSString *)getCachesDirectoryBigDocumentPath:(NSString *)documentName;
+ (NSString *)getCachesDirectorySmallDocumentPath:(NSString *)documentName;

+ (NSDate *)curretnDate;
+ (NSString *)curretnDateString;

@end
