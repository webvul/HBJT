//
//  EJAPIManager.h
//  hbjt
//
//  Created by 方秋鸣 on 16/2/22.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"
#import "EJS.h"

@interface EJAPIManager : NSObject

@property (strong, nonatomic) NSMutableDictionary *params;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) AFHTTPRequestSerializer *requestSerializer;
@property (strong, nonatomic) AFHTTPResponseSerializer *responseSerializer;
@property (strong, nonatomic) NSURLSessionTask *task;
@property (strong, nonatomic) id rawData;

- (instancetype)initWith:(NSString *)methodName params:(NSDictionary *)params;
- (void)launchPostRequestWithSuccess:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
- (void)launchWithSuccess:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;

@end
