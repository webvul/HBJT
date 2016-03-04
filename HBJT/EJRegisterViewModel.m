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

@property (strong, nonatomic) NSString *registerHint;

@end

@implementation EJRegisterViewModel


- (void)start
{
    self.usernameValidSignal = [[RACObserve(self, usernameText) map:^id(NSString *usernameText) {
        return @([FTVerifier verify:usernameText withRegex:@"^[A-Za-z]{6,18}$"]);
    }] distinctUntilChanged];
    self.passwordValidSignal = [[RACObserve(self, passwordText) map:^id(NSString *passwordText) {
        return @([FTVerifier verify:passwordText withRegex:@"^.{6,11}$"]);
    }] distinctUntilChanged];
    @weakify(self);
    self.confirmValidSignal = [[RACObserve(self, confirmText) map:^id(NSString *confirmText) {
        @strongify(self);
        return @([confirmText isEqualToString:self.passwordText]);
    }] distinctUntilChanged];
    self.nameValidSignal = [[RACObserve(self, nameText) map:^id(NSString *usernameText) {
        return @([FTVerifier verify:usernameText withRegex:@"^[\u4e00-\u9fa5]{2,8}$"]);
    }] distinctUntilChanged];
    self.numberValidSignal = [[RACObserve(self, numberText) map:^id(NSString *numberText) {
        return @([FTVerifier validIDNumberText:numberText]);
    }] distinctUntilChanged];
    self.phoneValidSignal = [[RACObserve(self, phoneText) map:^id(NSString *phoneText) {
        return @([FTVerifier verify:phoneText withRegex:@"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$"]);
    }] distinctUntilChanged];
    self.addressValidSignal = [[RACObserve(self, addressText) map:^id(NSString *addressText) {
        return @([FTVerifier verify:addressText withRegex:@"^.{6,16}$"]);
    }] distinctUntilChanged];
    self.userAgreedSignal = [RACObserve(self, isUserAgreed) distinctUntilChanged];
    self.userInputErrorSignal = [RACSignal combineLatest:@[self.usernameValidSignal, self.passwordValidSignal, self.confirmValidSignal, self.nameValidSignal,
                                                           self.numberValidSignal, self.addressValidSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid, NSNumber *confirmValid, NSNumber *nameValid, NSNumber *numberValid, NSNumber *addressValid) {
                                                               NSString *errorString = @"";
                                                               errorString = [errorString stringByAppendingString:([usernameValid boolValue]?nil:@"用户名格式不正确")];
                                                               errorString = [errorString stringByAppendingString:([passwordValid boolValue]?nil:@"密码格式不正确")];
                                                               errorString = [errorString stringByAppendingString:([usernameValid boolValue]?nil:@"密码两次输入不一致")];
                                                               errorString = [errorString stringByAppendingString:([usernameValid boolValue]?nil:@"请输入真实姓名")];
                                                               errorString = [errorString stringByAppendingString:([usernameValid boolValue]?nil:@"身份证号格式不正确")];
                                                               errorString = [errorString stringByAppendingString:([usernameValid boolValue]?nil:@"手机号格式不正确")];
                                                               errorString = [errorString stringByAppendingString:([usernameValid boolValue]?nil:@"请输入正确的联系地址")];
                                                               return errorString;
    }];
    
    self.registerSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:nil];
        [self.validateUsernameAPIManager launchRequestWithSuccess:^(id responseObject) {
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [self.registerAPIManager launchRequestWithSuccess:^(id responseObject) {
                [subscriber sendCompleted];
            } failure:^(NSError *error) {
                [subscriber sendError:error];
            }];
            return nil;
        }];
    }];
    self.registerHintSignal = [RACObserve(self, isRegisterProceed) map:^id(id value) {
        return self.registerHint;
    }];
}


- (void)registery
{
    self.isRegisterProceed = YES;
    [self.userInputErrorSignal subscribeNext:^(id x) {
        if (![x isEqualToString:@""]) {
            self.registerHint = x;
            self.isRegisterProceed = NO;
            return;
        }
    }];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.usernameText forKey:@"username"];
    [params setObject:self.passwordText forKey:@"password"];
    [params setObject:self.nameText forKey:@"realName"];
    [params setObject:self.numberText forKey:@"cardnum"];
    [params setObject:self.phoneText forKey:@"mobilephone"];
    [params setObject:self.addressText forKey:@"contractaddress"];
    self.registerAPIManager = [[EJRegisterAPIManager alloc] initWithParams:params];
    [self.registerSignal subscribeError:^(NSError *error) {
        self.registerHint = @"网络错误";
        self.isRegisterProceed = NO;
    } completed:^{
        self.isRegisterProceed = NO;
    }];

}

@end
