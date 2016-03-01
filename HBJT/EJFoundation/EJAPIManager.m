//
//  EJAPIManager.m
//  hbjt
//
//  Created by 方秋鸣 on 16/2/22.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJAPIManager.h"

@implementation EJAPIManager

- (instancetype)initWith:(NSString *)methodName params:(NSDictionary *)params;
{
    self = [self initWithDefault];
    if (self) {
        _url = [[EJSNetwork urlList] objectForKey:methodName];
        [_params addEntriesFromDictionary:params];
    }
    return self;
}

- (instancetype)initWithDefault
{
    self = [super init];
    if (self) {
        _params = [[NSMutableDictionary alloc]init];
        [_params setValue:[EJSNetwork key] forKey:@"key"];
        [_params setValue:[EJSNetwork token] forKey:@"token"];
        _requestSerializer = [AFHTTPRequestSerializer serializer];
        _responseSerializer = [AFJSONResponseSerializer serializer];
        _responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    }
    return self;
}

- (void)launchPostRequestWithSuccess:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock
{
    NSURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:self.url parameters:self.params error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = self.responseSerializer;
    @weakify(self);
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        @strongify(self);
        if (error) {
            NSLog(@"API MANAGER DID FAIL");
            failureBlock(error);
        } else {
            NSLog(@"API MANAGER DID SUCCEED");
            self.rawData = responseObject;
            successBlock(responseObject);
        }
    }];
    [dataTask resume];
}

- (void)launchWithSuccess:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock
{
    //Do nothing.
}

- (void)dealloc
{
    NSLog(@"[%@ APIMANAGER DEALLOC]", self);
}

@end
