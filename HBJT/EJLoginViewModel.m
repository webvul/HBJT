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

@property (assign, nonatomic) BOOL isLoginProceed;
@property (strong, nonatomic) NSString *loginTintText;

@property (strong, nonatomic) EJLoginAPIManager *loginAPIManager;

@property (strong, nonatomic) RACSignal *loginSignal;

@end

@implementation EJLoginViewModel

- (void)start
{
    @weakify(self);
    self.loginTintSignal = [RACObserve(self, isLoginProceed) merge:RACObserve(self, loginTintText)];
    self.loginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [subscriber sendNext:nil];
        [self.loginAPIManager launchRequestWithSuccess:^(id responseObject) {
            @strongify(self);
            if (![self.loginAPIManager status]) {
                [subscriber sendCompleted];
            } else
            {
                [subscriber sendError:nil];
            }
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
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:self.usernameText forKey:@"username"];
    [param setObject:self.passwordText forKey:@"password"];
    self.loginAPIManager = [[EJLoginAPIManager alloc]initWithParams:param];
    [self.loginSignal subscribeNext:^(id x) {
    } error:^(NSError *error) {
        self.loginTintText = @"网络错误";
        self.isLoginProceed = NO;
    } completed:^{
        self.loginTintText = @"登录成功";
        self.isLoginProceed = NO;
    }];    
}

- (BOOL)fetchLoginResult
{
    NSDictionary *data = [self.loginAPIManager data];
    self.loginTintText = [data valueForKeyPath:@"EJSUserinfo"];
    if ([[data valueForKeyPath:@"EJSCode"] isEqualToValue:@(0)]) {
        self.userinfo = [NSDictionary dictionaryWithDictionary:[data valueForKeyPath:@"data"]];
        return YES;
    }
    else
    {
        return NO;
    }
    
}

@end
