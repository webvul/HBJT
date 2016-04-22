//
//  EJMatterViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/10.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJMatterViewModel.h"
#import "EJQueryAPIManager.h"
#import "AppDelegate.h"

@interface EJMatterViewModel ()

@property (strong, nonatomic) RACSignal *querySignal;
@property (assign, nonatomic) NSInteger pageNumber;
@property (strong, nonatomic) EJQueryAPIManager *queryAPIManager;

@property (strong, nonatomic) NSMutableArray *matterDictionaryArray;

@end

@implementation EJMatterViewModel

- (void)autoStart
{
    @weakify(self);
    self.querySignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [subscriber sendNext:nil];
        [self.queryAPIManager launchRequestWithSuccess:^(id responseObject) {
            @strongify(self);
            if (![self.queryAPIManager newStatus]) {
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

- (void)queryNext
{
    [self query];
}

- (void)queryFirst
{
    self.pageNumber = 1;
    [self.queryAPIManager setPageNumber:@"1"];
    [self query];
}

- (void)query
{
    self.isNetworkProceed = YES;
    self.networkHintText = @"正在查询";
    @weakify(self);
    [self.querySignal subscribeError:^(NSError *error) {
        @strongify(self);
        self.networkHintText = self.queryAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        @strongify(self);
        self.matterDictionaryArray = [self.queryAPIManager.data objectForKey:@"matterDictionary"];
        self.pageNumber ++;
        self.networkHintText = @"查询成功";
        self.isNetworkProceed = NO;
    }];
}

- (EJQueryAPIManager *)queryAPIManager
{
    if (_queryAPIManager == nil) {
        _queryAPIManager = [[EJQueryAPIManager alloc] initWithQuerySection:(EJQueryAPIManagerSection)self.section ID:[[AppDelegate sharedDelegate] userIDString]];
    }
    return _queryAPIManager;
}

@end
