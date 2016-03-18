//
//  FTViewModel+EJSAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/15.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTViewModel+EJSAPIManager.h"

@implementation FTViewModel (EJSAPIManager)

- (RACSignal *)createSignalForAPIManager:(EJSAPIManager *)apiManager
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:nil];
        [apiManager launchRequestWithSuccess:^(id responseObject) {
            if (![apiManager newStatus]) {
                [subscriber sendCompleted];
            }
            else
            {
                [subscriber sendError:nil];
            }
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (void)subscribeNetworkSignal:(RACSignal *)signal apiManger:(EJSAPIManager *)apiManager
{
    self.isNetworkProceed = YES;
    [signal subscribeNext:^(id x) {
        self.networkHintText = x;
    } error:^(NSError *error) {
        self.networkHintText = apiManager.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        self.networkHintText = apiManager.statusDescription;
        self.isNetworkProceed = NO;
    }];
}


@end
