//
//  EJSuggestionViewModel.m
//  HBJT
//
//  Created by Davina on 16/3/14.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJSuggestionViewModel.h"
#import "EJSuggestionAPIManager.h"
#import "VerifyTool.h"

@interface EJSuggestionViewModel ()

@property (strong, nonatomic)EJSuggestionAPIManager *suggestionAPIManager;
@property (strong, nonatomic)RACSignal *suggestSignal;

@end

@implementation EJSuggestionViewModel

- (void)autoStart
{
    self.suggestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:nil];
        [self.suggestionAPIManager launchRequestWithSuccess:^(id responseObject) {
            if (![self.suggestionAPIManager newStatus]) {
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

- (void)suggest
{
    self.isNetworkProceed = YES;
    if (self.nameText.length > 20)
    {
        self.networkHintText = @"姓名长度过长";
        self.isNetworkProceed = NO;
        return;
    }
    if (!([self.phoneText isEqualToString:@""]||[VerifyTool validateMobile:self.phoneText]))
    {
        self.networkHintText = @"联系电话输入不正确";
        self.isNetworkProceed = NO;
        return;
    }
    
    if (!([self.qqText isEqualToString:@""]||[VerifyTool isQQ:self.qqText]))
    {
        self.networkHintText = @"QQ输入不正确";
        self.isNetworkProceed = NO;
        return;
    }
    
    if (!([self.emailText isEqualToString:@""]||[VerifyTool validateEmail:self.emailText]))
    {
        self.networkHintText = @"邮箱输入不正确";
        self.isNetworkProceed = NO;
        return;
    }
    
    if ([self.suggestionText isEqualToString:@""]) {
        self.networkHintText = @"请填写您的建议";
        self.isNetworkProceed = NO;
        return;
    }
    self.suggestionAPIManager = [[EJSuggestionAPIManager alloc]initWithSuggestion:self.suggestionText];
    [self.suggestSignal subscribeNext:^(id x) {
        self.networkHintText = x;
    } error:^(NSError *error) {
        self.networkHintText = self.suggestionAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        self.networkHintText = self.suggestionAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    }];}

@end
