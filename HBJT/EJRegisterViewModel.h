//
//  EJRegisterViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/4.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTViewModel.h"

@interface EJRegisterViewModel : FTViewModel

@property (strong, nonatomic) NSString  *usernameText;
@property (strong, nonatomic) NSString *passwordText;
@property (strong, nonatomic) NSString *confirmText;
@property (strong, nonatomic) NSString *nameText;
@property (strong, nonatomic) NSString *numberText;
@property (strong, nonatomic) NSString *phoneText;
@property (strong, nonatomic) NSString *addressText;
@property (assign, nonatomic) BOOL isUserAgreed;
@property (strong, nonatomic) RACSignal *usernameValidSignal;
@property (strong, nonatomic) RACSignal *passwordValidSignal;
@property (strong, nonatomic) RACSignal *confirmValidSignal;
@property (strong, nonatomic) RACSignal *nameValidSignal;
@property (strong, nonatomic) RACSignal *numberValidSignal;
@property (strong, nonatomic) RACSignal *phoneValidSignal;
@property (strong, nonatomic) RACSignal *addressValidSignal;
@property (strong, nonatomic) RACSignal *userAgreedSignal;
@property (strong, nonatomic) RACSignal *userInputErrorSignal;
@property (strong, nonatomic) RACSignal *registerHintSignal;

@property (assign, nonatomic) BOOL isRegisterProceed;
@property (assign, nonatomic) BOOL isRegisterSuccessed;

- (void)registery;

@end
