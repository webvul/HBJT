//
//  FTAPIManager.h
//  FTools
//
//  Created by 方秋鸣 on 16/2/22.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "FTools.h"

@interface FTAPIManager : NSObject

@property (strong, nonatomic) NSMutableDictionary *params;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) AFHTTPRequestSerializer *requestSerializer;
@property (strong, nonatomic) AFHTTPResponseSerializer *responseSerializer;
@property (strong, nonatomic) NSURLSessionTask *task;
@property (strong, nonatomic) NSString *requestMethod;
@property (strong, nonatomic) id rawData;
@property (assign, nonatomic) AFNetworkReachabilityStatus networkStatus;

- (instancetype)init;
- (void)launchRequestWithSuccess:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
- (void)cancel;

@end
