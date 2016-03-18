//
//  EJQueryAPIManager.m
//  HBJT
//
//  Created by Davina on 16/3/13.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJQueryAPIManager.h"

@interface EJQueryAPIManager ()

@end

@implementation EJQueryAPIManager

- (instancetype)initWithQuerySection:(EJQueryAPIManagerSection)section ID:(NSString *)userIDString
{
    NSString *methodName;
    switch (section) {
        case EJQueryAPIManagerSectionCaogao:
            methodName = kEJSNetworkAPINameQueryCaogao;
            break;
        case EJQueryAPIManagerSectionDaishen:
            methodName = kEJSNetworkAPINameQueryDaishen;
            break;
        case EJQueryAPIManagerSectionPingyi:
            methodName = kEJSNetworkAPINameQueryPingyi;
            break;
        case EJQueryAPIManagerSectionShouli:
            methodName = kEJSNetworkAPINameQueryShouli;
            break;
        case EJQueryAPIManagerSectionTuihui:
            methodName = kEJSNetworkAPINameQueryTuihui;
            break;
        case EJQueryAPIManagerSectionYiban:
            methodName = kEJSNetworkAPINameQueryYiban;
        default:
            break;
    }
    self = [super initWith:methodName];
    if (self) {
        [self.params setObject:@(1) forKey:@"pageNumber"];
        [self.params setObject:@(15) forKey:@"pageSize"];
        [self.params setObject:userIDString forKey:@"userid"];
    }
    return self;
}

- (void)setPageNumber:(NSString *)pageNumber
{
    [self.params setObject:pageNumber forKey:@"pageNumber"];
}

- (void)launchRequestWithSuccess:(void (^)(id))successBlock failure:(void (^)(NSError *))failureBlock
{
    if ((self.task == nil)||(self.task.state != NSURLSessionTaskStateRunning)) {
        [super launchRequestWithSuccess:successBlock failure:failureBlock];
    }
}

@end
