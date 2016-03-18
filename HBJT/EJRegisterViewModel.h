//
//  EJRegisterViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/4.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"

@interface EJRegisterViewModel : FTViewModel

//Receiver
@property (strong, nonatomic) NSString  *usernameText;
@property (strong, nonatomic) NSString *passwordText;
@property (strong, nonatomic) NSString *confirmText;
@property (strong, nonatomic) NSString *nameText;
@property (strong, nonatomic) NSString *numberText;
@property (strong, nonatomic) NSString *phoneText;
@property (strong, nonatomic) NSString *addressText;
@property (assign, nonatomic) BOOL isUserAgreed;

//Sender
@property (strong, nonatomic) RACSignal *registerHintSignal;
@property (strong, nonatomic) RACSignal *userAgreedSingal;

- (void)registery;

@end
