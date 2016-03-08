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

- (void)start
{
    @weakify(self);
    self.loginTintSignal = [RACObserve(self, isLoginProceed) merge:RACObserve(self, loginTintText)];
    self.loginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [subscriber sendNext:nil];
        [self.loginAPIManager launchRequestWithSuccess:^(id responseObject) {
            @strongify(self);
            if ([self.loginAPIManager newStatus] == 0) {
                NSLog(@"%tu",[self.loginAPIManager status]);
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
    @weakify(self);
    [self.loginSignal subscribeNext:^(id x) {
    } error:^(NSError *error) {
        @strongify(self);
        self.loginTintText = @"登录失败";
        switch (self.loginAPIManager.status) {
            case EJSAPIManagerStatusError:
                self.loginTintText = @"用户名或密码不正确";
                break;
            default:
                self.loginTintText = @"网络错误";
                break;
        }
        self.isLoginProceed = NO;
    } completed:^{
        @strongify(self);
        self.userinfo = self.loginAPIManager.data;
        [[AppDelegate sharedDelegate] setUsername:[self.userinfo objectForKey:@"usernaemString"]
                                           userID:[self.userinfo objectForKey:@"userIDString"]
                                       userNumber:[self.userinfo objectForKey:@"userNumerString"]
                                        userPhone:[self.userinfo objectForKey:@"userPhoneString"]
                                      userAddress:[self.userinfo objectForKey:@"userAddressString"]];
        self.loginTintText = @"登录成功";
        self.isLoginProceed = NO;
    }];
}
@end
