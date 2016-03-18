//
//  EJChangePasswordViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/4.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJChangePasswordViewModel.h"
#import "AppDelegate.h"
#import "EJChangePasswordAPIManager.h"
#import "EJVerityPasswordAPIManager.h"

@interface EJChangePasswordViewModel()

@property (strong, nonatomic) EJChangePasswordAPIManager *changePasswordAPIManager;
@property (strong, nonatomic) EJVerityPasswordAPIManager *verityPasswordAPIManager;
@property (assign, nonatomic) BOOL isChangePasswordProceed;
@property (strong, nonatomic) NSString *changePasswordHintText;
@property (strong, nonatomic) RACSignal *changePasswordSignal;

@end

@implementation EJChangePasswordViewModel

- (void)autoStart
{
    @weakify(self);
    self.changePasswordHintSignal = [[RACObserve(self, isChangePasswordProceed) merge:RACObserve(self, changePasswordHintText)] filter:^BOOL(id value) {
        @strongify(self);
        return self.isConnected;
    }];
    self.changePasswordSignal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [subscriber sendNext:nil];
        [self.verityPasswordAPIManager launchRequestWithSuccess:^(id responseObject) {
            @strongify(self);
            if (![self.verityPasswordAPIManager newStatus]) {
                [subscriber sendCompleted];
            }
            else
            {
                [subscriber sendError:nil];
            }
        } failure:^(NSError *error) {
            [subscriber sendError:nil];
        }];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [self.changePasswordAPIManager launchRequestWithSuccess:^(id responseObject) {
                @strongify(self);
                if (![self.changePasswordAPIManager newStatus]) {
                    [subscriber sendCompleted];
                } else
                {
                    [subscriber sendError:nil];
                }
            } failure:^(NSError *error) {
                [subscriber sendError:nil];
            }] ;
            return nil;
        }];
    }] filter:^BOOL(id value) {
        @strongify(self);
        return self.isConnected;
    }];
}

- (void)changePassword
{
    self.isChangePasswordProceed = YES;
    self.changePasswordHintText = @"正在修改";
    if (![FTVerifier verify:self.oldpasswordText withRegex:@"^.{6,11}$"]) {
        self.changePasswordHintText = @"原密码格式不正确";
        self.isChangePasswordProceed = NO;
        return;
    }
    if (![FTVerifier verify:self.passwordText withRegex:@"^.{6,11}$"]) {
        self.changePasswordHintText = @"新密码格式不正确";
        self.isChangePasswordProceed = NO;
        return;
    }
    if (![self.passwordText isEqualToString:self.confirmText]) {
        self.changePasswordHintText = @"密码两次输入不一致";
        self.isChangePasswordProceed = NO;
        return;
    }
    NSString *userIDString = [[AppDelegate sharedDelegate] userIDString];
    self.verityPasswordAPIManager = [[EJVerityPasswordAPIManager alloc]initWithID:userIDString password:self.oldpasswordText];
    self.changePasswordAPIManager = [[EJChangePasswordAPIManager alloc]initWithID:userIDString newPassword:self.passwordText];
    [self.changePasswordSignal subscribeError:^(NSError *error) {
        self.changePasswordHintText = (self.changePasswordAPIManager.status == EJSAPIManagerStatusUnset? self.verityPasswordAPIManager.statusDescription: self.changePasswordAPIManager.statusDescription);
        self.isChangePasswordProceed = NO;
    } completed:^{
        self.changePasswordHintText = @"密码修改成功";
        self.isChangePasswordProceed = NO;
    }];
}

@end
