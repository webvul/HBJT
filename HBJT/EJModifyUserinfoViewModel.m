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
    /*self.usernamePlaceHolderSiganal = [self mapSignalForUserinfoSignal:RACObserve([AppDelegate sharedDelegate], userUsernameString)];
    self.namePlaceHolderSiganal = [self mapSignalForUserinfoSignal:RACObserve([AppDelegate sharedDelegate], userNameString)];
    self.numberPlaceHolderSiganal = [self mapSignalForUserinfoSignal:RACObserve([AppDelegate sharedDelegate], userNumberString)];
    self.phonePlaceHolderSiganal = [self mapSignalForUserinfoSignal:RACObserve([AppDelegate sharedDelegate], userPhoneString)];
    self.addressPlaceHolderSiganal = [self mapSignalForUserinfoSignal:RACObserve([AppDelegate sharedDelegate], userAddressString)];*/
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
            if (![self.modifyUserinfoAPIManager newStatus]) {
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
    AppDelegate *delegate = [AppDelegate sharedDelegate];
    NSString *name = self.nameText;
    NSString *number = self.numberText;
    NSString *phone = self.phoneText;
    NSString *address = self.addressText;
//    if (![FTVerifier verify:name withRegex:@"^[\u4e00-\u9fa5]{1,16}$"]) {
//        self.modifyUserinfoHintText = @"真实姓名格式不正确";
//        self.isModifyUserinfoProceed = NO;
//        return;
//    }
    if (name.length < 1 || name.length > 16)
    {
        self.modifyUserinfoHintText = @"真实姓名长度不正确";
        self.isModifyUserinfoProceed = NO;
        return;
    }
    if (![FTVerifier validateIdentityCardNumberString:number]) {
        self.modifyUserinfoHintText = @"身份证号格式不正确";
        self.isModifyUserinfoProceed = NO;
        return;
    }
    if (![FTVerifier verify:phone withRegex:@"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$"]) {
        self.modifyUserinfoHintText = @"手机号码格式不正确";
        self.isModifyUserinfoProceed = NO;
        return;
    }
    if (![FTVerifier verify:address withRegex:@"^.{2,256}$"])
    {
        self.modifyUserinfoHintText = @"联系地址格式不正确";
        self.isModifyUserinfoProceed = NO;
        return;
    }
    self.modifyUserinfoAPIManager = [[EJModifyUserinfoAPIManager alloc]initWithID:[[AppDelegate sharedDelegate] userIDString] name:name number:number phone:phone address:address];
    @weakify(self);
    @weakify(delegate);
    [self.modifyUserinfoSignal subscribeNext:^(id x) {
    } error:^(NSError *error) {
        @strongify(self);
        self.modifyUserinfoHintText = self.modifyUserinfoAPIManager.statusDescription;
        self.isModifyUserinfoProceed = NO;
    } completed:^{
        @strongify(self);
        @strongify(delegate);
        [delegate modifyName:name
                      number:number
                       phone:phone
                     address:address];
        self.modifyUserinfoHintText = @"修改成功";
        self.isModifyUserinfoProceed = NO;
    }];
}

- (RACSignal *)mapSignalForUserinfoSignal:(RACSignal *)signal
{
    @weakify(self);
    return [[signal map:^id(id value) {
        return ([value isEqualToString:@"0"]? @"请补全信息": value);
    }] filter:^BOOL(id value) {
        @strongify(self);
        return self.isConnected;
    }];
}

@end
