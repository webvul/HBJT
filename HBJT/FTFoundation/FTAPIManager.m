//
//  FTAPIManager.m
//  FTools
//
//  Created by 方秋鸣 on 16/2/22.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTAPIManager.h"

@implementation FTAPIManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.params = [[NSMutableDictionary alloc]init];
        self.url = @"https://raw.githubusercontent.com/fangqiuming/FTools/test/FTools/TestResponse";
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.requestMethod = @"POST";
        self.requestSerializer.timeoutInterval = 10;
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            self.networkStatus = status;
        }];
        }
    return self;
}

- (void)launchRequestWithSuccess:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock
{
    NSURLRequest *request = [self.requestSerializer requestWithMethod:self.requestMethod URLString:self.url parameters:self.params error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = self.responseSerializer;
    @weakify(self);
    self.task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        @strongify(self);
        if (error) {
            NSLog(@"API MANAGER DID FAIL");
            [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
            failureBlock(error);
        } else {
            NSLog(@"API MANAGER DID SUCCEED");
            self.rawData = responseObject;
            [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
            successBlock(responseObject);
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [self.task resume];
}

- (void)dealloc
{
    [self.task cancel];
    NSLog(@"[%@ APIMANAGER DEALLOCING]", self);
}

@end
