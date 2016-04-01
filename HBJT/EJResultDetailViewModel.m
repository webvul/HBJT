//
//  ResultDetailViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/4/1.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJResultDetailViewModel.h"
#import "EJResultDetailAPIManager.h"
#import "EJProgressDetailAPIManager.h"

@interface EJResultDetailViewModel()

@property (strong, nonatomic) EJSAPIManager *resultAPIManager;

@property (strong, nonatomic) RACSignal *resultSignal;
@property (strong, nonatomic) RACSignal *progressSignal;

@end

@implementation EJResultDetailViewModel


- (void)autoStart
{
    @weakify(self);
    self.resultSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.resultAPIManager launchRequestWithSuccess:^(id responseObject) {
            @strongify(self);
            if ([self.resultAPIManager newStatus]) {
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

- (void)load
{
    @weakify(self);
    self.isNetworkProceed = YES;
    self.resultAPIManager = (self.resultType == 0? [[EJProgressDetailAPIManager alloc] initWithID:self.resultID]: [[EJResultDetailAPIManager alloc] initWithID:self.resultID]);
    [self.resultSignal subscribeError:^(NSError *error) {
        @strongify(self);
        self.networkHintText = self.resultAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        @strongify(self);
        self.networkHintText = self.resultAPIManager.statusDescription;
        self.data = self.resultAPIManager.data;
        self.isNetworkProceed = NO;
    }];
}

@end
