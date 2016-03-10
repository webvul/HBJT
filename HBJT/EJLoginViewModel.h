//
//  LoginViewModel.h
//  hbjt
//
//  Created by 方秋鸣 on 16/1/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"

@interface EJLoginViewModel : FTViewModel

//Receiver
@property (strong, nonatomic) NSString *usernameText;
@property (strong, nonatomic) NSString *passwordText;

//Sender
@property (strong, nonatomic) RACSignal *loginTintSignal;

//Package
@property (strong, nonatomic) NSDictionary *userinfo;

- (void)login;

@end
