//
//  NetWorkObject.h
//  Meet
//
//  Created by jiahui on 16/5/8.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"

@interface NetWorkObject : NSObject


+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
