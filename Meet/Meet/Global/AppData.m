//
//  AppData.m
//  EasyBusiness
//
//  Created by jiahui on 15/10/13.
//  Copyright (c) 2015年 YouZai. All rights reserved.
//

#import "AppData.h"

@implementation AppData

static AppData *appData = nil;

+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appData = [[AppData alloc] init];
        appData.userInfo = [UserInfo shareInstance];
        appData.wxAppID = @"wx49c4b6f590f83469";
        appData.wxAppSecret = @"dad2dab904e70125dcc50ea066809a20";
    });
    return appData;
}

#pragma mark - dataBase operation
NSString *const UserInfoDatabaseName = @"MeetUserDB.db";
- (BOOL)initUserDataBaseToDocument {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:UserInfoDatabaseName];
    if (!_db) {
        self.db = [FMDatabase databaseWithPath:dbPath];
    }
    if (![_db open]) {
        NSLog(@"不能打开数据库！");
        return NO;
    } else {
        
    }
    return YES;
}


#pragma mark - FilePath
+ (NSString *)getCachesDirectoryDocumentPath:(NSString *)documentName {
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cacheDirectoryPath stringByAppendingPathComponent:documentName];
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:path]) {
//        NSLog(@"File not found Couldn't find the file at path: %@",path);
        if ([mager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
            return path;
        } else {
             NSLog(@"创建 %@ 失败",documentName);
            return nil;
        }
    } else
        return path;
}

+ (NSString *)getCachesDirectoryBigDocumentPath:(NSString *)documentName {
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cacheDirectoryPath stringByAppendingPathComponent:documentName];
    NSString *bigImagePath = [path stringByAppendingPathComponent:@"/big"];
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:bigImagePath]) {
        //        NSLog(@"File not found Couldn't find the file at path: %@",path);
        if ([mager createDirectoryAtPath:bigImagePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return bigImagePath;
        } else {
            NSLog(@"创建 %@ 失败",documentName);
            return nil;
        }
    } else
        return bigImagePath;
}


+ (NSString *)getCachesDirectorySmallDocumentPath:(NSString *)documentName {
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *bigImagePath = [cacheDirectoryPath stringByAppendingPathComponent:documentName];
    NSString *smallImagePath = [bigImagePath stringByAppendingPathComponent:@"/small"];
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:smallImagePath]) {
        //        NSLog(@"File not found Couldn't find the file at path: %@",path);
        if ([mager createDirectoryAtPath:smallImagePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return smallImagePath;
        } else {
            NSLog(@"创建 %@ 失败",documentName);
            return nil;
        }
    } else
        return smallImagePath;
}


- (NSString *)getCachesSmallImageWithImageIndexPath:(NSIndexPath *)indexPath {///
    NSString *indexPathDomPath = [self getCacheContetnImagePathWithIndexPath:indexPath];
    NSString *smallPaht = [indexPathDomPath stringByAppendingPathComponent:@"small"];
    
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:smallPaht]) {
        //        NSLog(@"File not found Couldn't find the file at path: %@",path);
        if ([mager createDirectoryAtPath:smallPaht withIntermediateDirectories:YES attributes:nil error:nil]) {
            return smallPaht;
        } else {
            NSLog(@"创建 %@ 失败",smallPaht);
            return nil;
        }
    } else
        return smallPaht;
}

- (NSString *)getCachesBigImageWithImageIndexPath:(NSIndexPath *)indexPath {///
    NSString *indexPathDomPath = [self getCacheContetnImagePathWithIndexPath:indexPath];
    NSString *bigPaht = [indexPathDomPath stringByAppendingPathComponent:@"big"];
    
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:bigPaht]) {
        //        NSLog(@"File not found Couldn't find the file at path: %@",path);
        if ([mager createDirectoryAtPath:bigPaht withIntermediateDirectories:YES attributes:nil error:nil]) {
            return bigPaht;
        } else {
            NSLog(@"创建 %@ 失败",bigPaht);
            return nil;
        }
    } else
        return bigPaht;
}

- (NSString *)getCacheContetnImagePathWithIndexPath:(NSIndexPath *)indexPath {
    NSString *path = [self getCacheMostContetnImagePath];
    NSString *indexSectionPath = [path stringByAppendingPathComponent:FORMAT(@"%ld",(long)indexPath.section)];
    NSString *indexRowPath = [indexSectionPath stringByAppendingPathComponent:FORMAT(@"%ld",(long)indexPath.row)];
    
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:indexRowPath]) {
        //        NSLog(@"File not found Couldn't find the file at path: %@",path);
        if ([mager createDirectoryAtPath:indexRowPath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return indexRowPath;
        } else {
            NSLog(@"创建 %@ 失败",indexRowPath);
            return nil;
        }
    } else
        return indexRowPath;
}

- (NSString *)getCacheMostContetnImagePath {/////更多信息内容路径
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cacheDirectoryPath stringByAppendingPathComponent:[UserInfo shareInstance].userId];
    NSString *mostPath = [path stringByAppendingPathComponent:@"MostContent"];
    
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:mostPath]) {
        //        NSLog(@"File not found Couldn't find the file at path: %@",path);
        if ([mager createDirectoryAtPath:mostPath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return mostPath;
        } else {
            NSLog(@"创建 %@ 失败",mostPath);
            return nil;
        }
    } else
        return mostPath;
}

+ (NSString *)getCachesDirectoryUserInfoDocumetPathDocument:(NSString *)document {//
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cacheDirectoryPath stringByAppendingPathComponent:[[UserInfo shareInstance].userId stringByAppendingPathComponent:document]];
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:path]) {
        //        NSLog(@"File not found Couldn't find the file at path: %@",path);
        if ([mager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
            return path;
        } else {
            NSLog(@"创建 %@ 失败",document);
            return nil;
        }
    } else
        return path;
}

#pragma mark - other
+ (NSString *)random_uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

#pragma mark - NSDate
//获取当前时间和日期
+ (NSString *)curretnDateString
{
    NSDate *  senddate=[NSDate date];
    //    NSLog(@"%@",senddate);
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    //    NSLog(@"当前时间为%@",locationString);
    
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *  nsDateString= [NSString  stringWithFormat:@"%4ld-%ld-%ld ",(long)year,(long)month,(long)day];
    nsDateString = [nsDateString stringByAppendingString:locationString];
    return nsDateString;
}

+ (NSDate *)curretnDate//获取当前时间
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];//28800
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSDate *)getDateFromString:(NSString *)pstrDate
{
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *dtPostDate = [df1 dateFromString:pstrDate];
    return dtPostDate;
}

@end
