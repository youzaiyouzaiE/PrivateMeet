//
//  NetWorkObject.m
//  Meet
//
//  Created by jiahui on 16/5/8.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "NetWorkObject.h"

@implementation NetWorkObject

- (NSURLSessionDownloadTask *)creatingDownloadTaskURL:(NSURL *)URL {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
    return downloadTask;
}

+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress *))downloadProgress
                      success:(void (^)(NSURLSessionDataTask *, id))success
                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.securityPolicy.allowInvalidCertificates = NO;
    manager.requestSerializer.timeoutInterval = 10.0f;
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableSet *acceptContentTypes = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [acceptContentTypes addObject:@"text/plain"];
    [acceptContentTypes addObject:@"text/html"];
    [acceptContentTypes addObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = acceptContentTypes;
    
    NSURLSessionDataTask *stack =  [manager GET:(NSString *)URLString
                             parameters:(id)parameters
                               progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                                failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure];
    [stack resume];
    return stack;
}

+ (NSURLSessionDownloadTask *)downloadTask:(NSString *)URLString
                                  progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                               destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                         completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                                                                  destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                                            completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler];
        [downloadTask resume];
    return downloadTask;
}



@end
