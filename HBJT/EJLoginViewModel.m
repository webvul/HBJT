//
//  LoginViewModel.m
//  hbjt
//
//  Created by 方秋鸣 on 16/1/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJLoginViewModel.h"
#import "EJLoginAPIManager.h"
#import "EJValidateUsernameAPIManager.h"
#import "EJS.h"


@interface EJLoginViewModel()

@property (strong, nonatomic) EJLoginAPIManager *loginAPIManager;

@property (strong, nonatomic) RACSignal* loginSignal;

@end

@implementation EJLoginViewModel

- (void)start
{
    self.usernameValidSignal = [[RACObserve(self, usernameText) map:^id(NSString *usernameText) {
        return @([FTVerifier verify:usernameText withRegex:@"^[A-Za-z]{6,18}$"]);
    }] distinctUntilChanged];
    self.passwordValidSignal = [[RACObserve(self, passwordText) map:^id(NSString *passwordText) {
        return @([FTVerifier verify:passwordText withRegex:@"^.{6,16}$"]);
    }] distinctUntilChanged];
    self.loginButtonEnableSignal = [RACSignal combineLatest:@[self.usernameValidSignal, self.passwordValidSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid)
    {
        return @([usernameValid boolValue]&&[passwordValid boolValue]);
    }];
    self.loginProceedSignal = nil;
    self.loginTintSignal = [RACObserve(self, isLoginProceed) merge:RACObserve(self, loginTintText)];
    
    self.loginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:nil];
        [self.loginAPIManager launchRequestWithSuccess:^(id responseObject) {
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
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
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:self.usernameText forKey:@"username"];
    [param setObject:self.passwordText forKey:@"password"];
    self.loginAPIManager = [[EJLoginAPIManager alloc]initWithParams:param];
    [self.loginSignal subscribeNext:^(id x) {
    } error:^(NSError *error) {
        self.loginTintText = @"网络错误";
        self.isLoginProceed = NO;
    } completed:^{
    }];    
}

@end
