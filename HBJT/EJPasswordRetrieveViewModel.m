//
//  EJPasswordRetrieveViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/29.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJPasswordRetrieveViewModel.h"
#import "EJPasswordRetrieveAPIManager.h"
#import "EJVeriftyPhoneNumberAPIManager.h"

@interface EJPasswordRetrieveViewModel()

@property (strong, nonatomic) EJPasswordRetrieveAPIManager *passwordAPIManager;
@property (strong, nonatomic) EJVeriftyPhoneNumberAPIManager *phoneNumberAPIManager;

@property (strong, nonatomic) RACSignal *retrieveSignal;
@property (strong, nonatomic) RACSignal *veriftySignal;

@property (strong, nonatomic) NSString *phoneNumber;
@property (assign ,nonatomic) BOOL phoneVerified;
@property (strong, nonatomic) NSString *code;





@end

@implementation EJPasswordRetrieveViewModel

- (void)autoStart
{
    @weakify(self);
    self.retrieveSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.passwordAPIManager launchRequestWithSuccess:^(id responseObject) {
            @strongify(self);
            if ([self.passwordAPIManager newStatus]) {
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
    self.veriftySignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.phoneNumberAPIManager launchRequestWithSuccess:^(id responseObject) {
            @strongify(self);
            if ([self.phoneNumberAPIManager newStatus]) {
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
    [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        if (self.timeCount > 0) {
            self.timeCount --;
        }
    }];
}

- (void)verifyPhone
{
    if (self.timeCount > 0) {
        return;
    }
    self.isNetworkProceed = YES;
    self.networkHintText = @"正在发送请求";
    if (![FTVerifier verify:self.phoneNumberText withRegex:@"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$"]) {
        self.networkHintText = @"手机号码格式不正确";
        self.isNetworkProceed = NO;
        return;
    }
    self.phoneNumberAPIManager = [[EJVeriftyPhoneNumberAPIManager alloc] initWithPhoneNumber:self.phoneNumberText];
    self.phoneNumber = self.phoneNumberText;
    [self.veriftySignal subscribeError:^(NSError *error) {
        self.networkHintText = self.phoneNumberAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        self.code = [self.phoneNumberAPIManager.data objectForKey:@"code"];
        self.phoneVerified = YES;
        self.networkHintText = self.phoneNumberAPIManager.statusDescription;
        self.isNetworkProceed = NO;
        self.timeCount = 60;
    }];

}

- (void)retrievePassword
{
    self.isNetworkProceed = YES;
    self.networkHintText = @"正在发送请求";
    if (!self.phoneVerified)
    {
        self.networkHintText = @"请先获取验证码";
        self.isNetworkProceed = NO;
        return;
    }
    if (![self.codeText isEqualToString:self.code])
    {
        self.networkHintText = @"验证码输入错误";
        self.isNetworkProceed = NO;
        return;
    }
    if (![FTVerifier verify:self.usernameText withRegex:@"^[A-Za-z0-9]{1,16}$"]) {
        self.networkHintText = @"用户名格式不正确";
        self.isNetworkProceed = NO;
        return;
    }
    if (![FTVerifier verify:self.passwordText withRegex:@"^.{6,18}$"]) {
        self.networkHintText = @"密码格式不正确";
        self.isNetworkProceed = NO;
        return;
    }
    if (![self.repeatPasswordText isEqualToString:self.passwordText]) {
        self.networkHintText = @"密码两次输入不一致";
        self.isNetworkProceed = NO;
        return;
    }
    self.passwordAPIManager = [[EJPasswordRetrieveAPIManager alloc] initWithUsername:self.usernameText newPassword:self.passwordText phoneNumber:self.phoneNumber];
    [self.retrieveSignal subscribeError:^(NSError *error) {
        self.networkHintText = self.passwordAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        self.networkHintText = self.passwordAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    }];
}

@end
