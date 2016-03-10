//
//  EJModifyUserinfoViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/4.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJModifyUserinfoViewModel.h"
#import "EJModifyUserinfoAPIManager.h"
#import "AppDelegate.h"

@interface EJModifyUserinfoViewModel ()

@property (assign, nonatomic) BOOL isModifyUserinfoProceed;
@property (assign, nonatomic) NSString *modifyUserinfoHintText;
@property (strong, nonatomic) RACSignal *modifyUserinfoSignal;
@property (strong, nonatomic) EJModifyUserinfoAPIManager *modifyUserinfoAPIManager;

@end

@implementation EJModifyUserinfoViewModel

- (void)autoStart
{
    self.usernamePlaceHolderSiganal = [self mapSignalForUserinfoSignal:RACObserve([AppDelegate sharedDelegate], userUsernameString)];
    self.namePlaceHolderSiganal = [self mapSignalForUserinfoSignal:RACObserve([AppDelegate sharedDelegate], userNameString)];
    self.numberPlaceHolderSiganal = [self mapSignalForUserinfoSignal:RACObserve([AppDelegate sharedDelegate], userNumberString)];
    self.phonePlaceHolderSiganal = [self mapSignalForUserinfoSignal:RACObserve([AppDelegate sharedDelegate], userPhoneString)];
    self.addressPlaceHolderSiganal = [self mapSignalForUserinfoSignal:RACObserve([AppDelegate sharedDelegate], userAddressString)];
    @weakify(self);
    self.modifyUserinfoHintSignal = [[RACObserve(self, isModifyUserinfoProceed) merge:RACObserve(self, modifyUserinfoHintText)] filter:^BOOL(id value) {
        @strongify(self);
        return self.isConnected;
    }];
    self.modifyUserinfoSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [subscriber sendNext:nil];
        [self.modifyUserinfoAPIManager launchRequestWithSuccess:^(id responseObject) {
            @strongify(self);
            if ([self.modifyUserinfoAPIManager newStatus]) {
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

- (void)modifyUserinfo
{
    self.isModifyUserinfoProceed = YES;
    self.modifyUserinfoHintText = @"正在修改";
    self.modifyUserinfoAPIManager = [[EJModifyUserinfoAPIManager alloc]initWithID:[[AppDelegate sharedDelegate] userIDString] name:self.nameText number:self.numberText phone:self.phoneText address:self.addressText];
    @weakify(self);
    [self.modifyUserinfoSignal subscribeNext:^(id x) {
    } error:^(NSError *error) {
        @strongify(self);
        self.modifyUserinfoHintText = self.modifyUserinfoAPIManager.statusDescription;
        self.isModifyUserinfoProceed = NO;
    } completed:^{
        @strongify(self);
        self.modifyUserinfoHintText = @"修改成功";
        self.isModifyUserinfoProceed = NO;
        [[AppDelegate sharedDelegate] modifyName:self.nameText
                                          number:self.numberText
                                           phone:self.phoneText
                                         address:self.addressText];
    }];
}

- (RACSignal *)mapSignalForUserinfoSignal:(RACSignal *)signal
{
    @weakify(self);
    return [[signal map:^id(id value) {
        return ([value isEqualToString:@"0"]? @"": value);
    }] filter:^BOOL(id value) {
        @strongify(self);
        return self.isConnected;
    }];
}

@end
