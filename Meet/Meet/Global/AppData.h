//
//  AppData.h
//  EasyBusiness
//
//  Created by jiahui on 15/10/13.
//  Copyright (c) 2015年 YouZai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "UserInfo.h"

@interface AppData : NSObject

@property (strong, nonatomic) FMDatabase *db;
@property (assign, nonatomic) BOOL isLogin;

@property (nonatomic, strong) UserInfo *userInfo;
@property (copy, nonatomic) NSString *wxAppID;
@property (copy, nonatomic) NSString *wxAppSecret;
@property (copy, nonatomic) NSString *wxRandomState;////对比授权的标识符
@property (copy, nonatomic) NSString *wxAccess_token;


+ (instancetype) shareInstance;

- (BOOL)initUserDataBaseToDocument;

+ (NSString *)random_uuid;
+ (NSString *)getCachesDirectoryDocumentPath:(NSString *)documentName;
+ (NSString *)getCachesDirectoryBigDocumentPath:(NSString *)documentName;
+ (NSString *)getCachesDirectorySmallDocumentPath:(NSString *)documentName;
+ (NSString *)getCachesDirectoryUserInfoDocumetPathDocument:(NSString *)document;

- (NSString *)getCacheContetnImagePathWithIndexPath:(NSIndexPath *)indexPath;
- (NSString *)getCachesBigImageWithImageIndexPath:(NSIndexPath *)indexPath;
- (NSString *)getCachesSmallImageWithImageIndexPath:(NSIndexPath *)indexPath;
- (NSString *)getCacheMostContetnImagePath;

+ (NSDate *)curretnDate;
+ (NSString *)curretnDateString;

@end
