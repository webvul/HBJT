//
//  LoginViewModel.m
//  hbjt
//
//  Created by 方秋鸣 on 16/1/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "AppDelegate.h"
#import "EJLoginViewModel.h"
#import "EJLoginAPIManager.h"


@interface EJLoginViewModel()

@property (assign, nonatomic) BOOL isLoginProceed;
@property (strong, nonatomic) NSString *loginTintText;
@property (strong, nonatomic) EJLoginAPIManager *loginAPIManager;
@property (strong, nonatomic) RACSignal *loginSignal;

@end

@implementation EJLoginViewModel

- (void)autoStart
{
    @weakify(self);
    self.loginTintSignal = [[RACObserve(self, isLoginProceed) merge:RACObserve(self, loginTintText)] filter:^BOOL(id value) {
        @strongify(self);
        return self.isConnected;
    }];
    self.loginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [subscriber sendNext:nil];
        [self.loginAPIManager launchRequestWithSuccess:^(id responseObject) {
            @strongify(self);
            ([self.loginAPIManager newStatus] == 0? [subscriber sendCompleted]: [subscriber sendError:nil]);
        } failure:^(NSError *error) {
            [subscriber sendError:nil];
        }];
        return nil;
    }];
}

- (void)login
{
    self.isLoginProceed = YES;
    self.loginTintText = @"正在登录";
    if (![FTVerifier verify:self.usernameText withRegex:@"^[A-Za-z]{6,18}$"]) {
        self.loginTintText = @"用户名格式不正确";
        self.isLoginProceed = NO;
        return;
    }
    if (![FTVerifier verify:self.passwordText withRegex:@"^.{6,16}$"]) {
        self.loginTintText = @"密码格式不正确";
        self.isLoginProceed = NO;
        return;
    }
    self.loginAPIManager = [[EJLoginAPIManager alloc]initWithUsername:self.usernameText password:self.passwordText];
    @weakify(self);
    [self.loginSignal subscribeError:^(NSError *error) {
        @strongify(self);
        self.loginTintText = self.loginAPIManager.statusDescription;
        self.isLoginProceed = NO;
    } completed:^{
        @strongify(self);
        self.userinfo = self.loginAPIManager.data;
        [[AppDelegate sharedDelegate] setUsername:[self.userinfo objectForKey:@"userUsernameString"]
                                             name:[self.userinfo objectForKey:@"userNameString"]
                                               id:[self.userinfo objectForKey:@"userIDString"]
                                           number:[self.userinfo objectForKey:@"userNumberString"]
                                            phone:[self.userinfo objectForKey:@"userPhoneString"]
                                          address:[self.userinfo objectForKey:@"userAddressString"]];
        self.loginTintText = @"登录成功";
        self.isLoginProceed = NO;
    }];
}

@end
