//
//  EJRegisterViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/4.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJRegisterViewModel.h"
#import "EJValidateUsernameAPIManager.h"
#import "EJRegisterAPIManager.h"


@interface EJRegisterViewModel ()

@property (strong, nonatomic) RACSignal *registerSignal;
@property (strong, nonatomic) EJRegisterAPIManager *registerAPIManager;
@property (strong, nonatomic) EJValidateUsernameAPIManager *validateUsernameAPIManager;

@property (strong, nonatomic) NSString *registerHintText;
@property (assign, nonatomic) BOOL isRegisterProceed;
@property (assign, nonatomic) BOOL isUsernameUnique;
@property (assign, nonatomic) NSDictionary *userinfo;

@end

@implementation EJRegisterViewModel


- (void)autoStart
{
    self.registerHintSignal = [RACObserve(self, isRegisterProceed) merge:RACObserve(self, registerHintText)];
    self.userAgreedSingal = RACObserve(self, isUserAgreed);
    self.registerSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.validateUsernameAPIManager launchRequestWithSuccess:^(id responseObject) {
            ([self.validateUsernameAPIManager newStatus] == 0? [subscriber sendCompleted]: [subscriber sendError:nil]);
        } failure:^(NSError *error) {
            NSLog(@"%@",error.userInfo);
            [subscriber sendError:error];
        }];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [self.registerAPIManager launchRequestWithSuccess:^(id responseObject) {
                ([self.registerAPIManager newStatus] == 0? [subscriber sendCompleted]: [subscriber sendError:nil]);
            } failure:^(NSError *error) {
                NSLog(@"%@",error.userInfo);
                [subscriber sendError:error];
            }];
            return nil;
        }];
    }];
}


- (void)registery
{
    self.isRegisterProceed = YES;
    self.registerHintText = @"正在注册";
    if(![FTVerifier verify:self.usernameText withRegex:@"^[A-Za-z]{6,18}$"])
    {
        self.registerHintText = @"用户名格式不正确";
        self.isRegisterProceed = NO;
        return;
    }
    if (![FTVerifier verify:self.passwordText withRegex:@"^.{6,11}$"]) {
        self.registerHintText = @"密码格式不正确";
        self.isRegisterProceed = NO;
        return;
    }/*
    if (![self.confirmText isEqualToString:self.passwordText]) {
        self.registerHintText = @"密码两次输入不一致";
        self.isRegisterProceed = NO;
        return;
    }
    if (![FTVerifier verify:self.nameText withRegex:@"^[\u4e00-\u9fa5]{2,8}$"]) {
        self.registerHintText = @"姓名格式不正确";
        self.isRegisterProceed = NO;
        return;
    }
    if (![FTVerifier validateIdentityCardNumberString:self.numberText]) {
        self.registerHintText = @"身份证号格式不正确";
        self.isRegisterProceed = NO;
        return;
    }
    if (![FTVerifier verify:self.phoneText withRegex:@"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$"]) {
        self.registerHintText = @"手机号码格式不正确";
        self.isRegisterProceed = NO;
        return;
    }
    if (![FTVerifier verify:self.addressText withRegex:@"^.{6,16}$"])
    {
        self.registerHintText = @"联系地址格式不正确";
        self.isRegisterProceed = NO;
        return;
    }
    if (!self.isUserAgreed) {
        self.registerHintText = @"请确认同意用户协议";
        self.isRegisterProceed = NO;
        return;
    }*/
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.usernameText forKey:@"username"];
    self.validateUsernameAPIManager = [[EJValidateUsernameAPIManager alloc] initWithParams:params];
    [params setObject:self.passwordText forKey:@"password"];
    [params setObject:self.nameText forKey:@"realName"];
    [params setObject:self.numberText forKey:@"cardnum"];
    [params setObject:self.phoneText forKey:@"mobilephone"];
    [params setObject:self.addressText forKey:@"contractaddress"];
    self.registerAPIManager = [[EJRegisterAPIManager alloc] initWithParams:params];
    [self.registerSignal subscribeError:^(NSError *error) {
        self.registerHintText = (self.registerAPIManager.status == EJSAPIManagerStatusUnset? self.validateUsernameAPIManager.statusDescription: self.registerAPIManager.statusDescription);
        self.isRegisterProceed = NO;
    } completed:^{
        self.registerHintText = @"注册成功";
        self.isRegisterProceed = NO;
    }];

}

@end
