//
//  EJFollowViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/4/13.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//
#import "EJFollowListAPIManager.h"
#import "EJFollowViewModel.h"
#import "AppDelegate.h"

@interface EJFollowViewModel ()

@property (strong, nonatomic) RACSignal *listSignal;
@property (strong, nonatomic) EJFollowListAPIManager *listAPIManager;
@property (strong, nonatomic) NSNumber *pageNumber;
@end

@implementation EJFollowViewModel

- (void)autoStart
{
    self.pageNumber = @1;
    @weakify(self);
    self.listSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.listAPIManager launchRequestWithSuccess:^(id responseObject) {
            if (![self.listAPIManager newStatus]) {
                [subscriber sendCompleted];
            }
            else{
                [subscriber sendError:nil];
            }
        } failure:^(NSError *error) {
            [subscriber sendError:nil];
        }];
        return nil;
    }];
    [self connect];
}

- (void)fetchList
{
    AppDelegate *delegate = [AppDelegate sharedDelegate];
    self.isNetworkProceed = YES;
    self.networkHintText = @"正在获取";
    if (![delegate currentUser]) {
        self.networkHintText = @"请先登录";
        self.isNetworkProceed = NO;
        return;
    }
    self.listAPIManager = [[EJFollowListAPIManager alloc]initWithUserID:delegate.userIDString pageNumber:self.pageNumber];
    [self.listSignal subscribeError:^(NSError *error) {
        self.networkHintText = self.listAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        self.itemList = [self.listAPIManager.data objectForKey:@"content"];
        self.networkHintText = self.listAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    }];
                           
}

@end
