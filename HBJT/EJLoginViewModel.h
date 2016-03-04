//
//  LoginViewModel.h
//  hbjt
//
//  Created by 方秋鸣 on 16/1/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"

@interface EJLoginViewModel : FTViewModel

@property (strong, nonatomic) RACSignal *usernameValidSignal;
@property (strong, nonatomic) RACSignal *passwordValidSignal;
@property (strong, nonatomic) RACSignal *loginButtonEnableSignal;


@property (assign, nonatomic) BOOL isLoginProceed;
@property (assign, nonatomic) BOOL isLoginSuccessed;
@property (assign, nonatomic) BOOL isLoginEnabled;

@property (strong, nonatomic) NSString *loginTintText;
//@property (strong, nonatomic) FFWDummyManager *dummyManager;

//Receiver
@property (strong, nonatomic) NSString *usernameText;
@property (strong, nonatomic) NSString *passwordText;
//Sender
@property (strong, nonatomic) RACSignal *loginTintSignal;
@property (strong, nonatomic) RACSignal *loginProceedSignal;


- (void)login;

@end
