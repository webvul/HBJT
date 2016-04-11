//
//  EJNewsDetailViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/28.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJNewsDetailViewModel.h"
#import "EJWebsiteArticleDetailAPIManager.h"
#import "EJWebsiteArticleLaudAPIManager.h"

@interface EJNewsDetailViewModel ()

@property (strong, nonatomic) EJWebsiteArticleDetailAPIManager *detailAPIManger;
@property (strong, nonatomic) EJWebsiteArticleLaudAPIManager *laudAPIManger;
@property (strong, nonatomic) RACSignal *detailSignal;
@property (strong, nonatomic) RACSignal *laudSiganl;

@end

@implementation EJNewsDetailViewModel

- (void)autoStart
{
    @weakify(self);
    self.detailSignal  = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.detailAPIManger launchRequestWithSuccess:^(id responseObject) {
            if ([self.detailAPIManger newStatus]) {
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

- (void)loadArticleDetail
{
    @weakify(self);
    self.detailAPIManger = [[EJWebsiteArticleDetailAPIManager alloc]initWithArticleID:self.articleID];
    self.isNetworkProceed = YES;
    self.networkHintText = @"正在读取";
    [self.detailSignal subscribeError:^(NSError *error) {
        @strongify(self);
        self.networkHintText = self.detailAPIManger.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        self.htmlString = [self.detailAPIManger.data objectForKey:@"htmlString"];
        self.networkHintText = self.detailAPIManger.statusDescription;
        self.isNetworkProceed = NO;
    }];
}

@end