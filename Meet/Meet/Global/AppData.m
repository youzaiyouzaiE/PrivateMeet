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
NSString *const databaseName = @"MeetDB.db";
- (BOOL)initDataBaseToDocument {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:databaseName];
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


+ (NSString *)getCachesDirectoryUserInfoDocumetPathDocument:(NSString *)document {/////得到当前微信用户微信文件
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
    NSString *  nsDateString= [NSString  stringWithFormat:@"%4d-%d-%d ",year,month,day];
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

@end
