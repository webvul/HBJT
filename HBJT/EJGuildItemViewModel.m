//
//  EJGuildItemViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJGuildItemViewModel.h"
#import "EJItemAPIManager.h"

@interface EJGuildItemViewModel ()

@property (nonatomic, strong) RACSignal *loadItemListSignal;
@property (nonatomic, strong) EJItemAPIManager *itemAPIManger;

@end

@implementation EJGuildItemViewModel

- (void)autoStart
{
    @weakify(self);
    self.loadItemListSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.itemAPIManger launchRequestWithSuccess:^(id responseObject) {
            @strongify(self);
            if ([self.itemAPIManger newStatus]) {
                [subscriber sendError:nil];
            }
            else
            {
                [subscriber sendCompleted];
            }
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (void)loadItemList
{
    self.itemAPIManger = [[EJItemAPIManager alloc] initWIthPrimaryItemID:self.primaryItemIDString];
    self.isNetworkProceed = YES;
    [self.loadItemListSignal subscribeError:^(NSError *error) {
        self.networkHintText = self.itemAPIManger.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        self.itemList = [self.itemAPIManger.data objectForKey:@"itemArray"];
        self.networkHintText = self.itemAPIManger.statusDescription;
        self.isNetworkProceed = NO;
    }];
}

@end
