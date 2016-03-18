//
//  EJChangePasswordViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/4.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTViewModel.h"

@interface EJChangePasswordViewModel : FTViewModel

@property (strong, nonatomic) NSString *oldpasswordText;
@property (strong, nonatomic) NSString *passwordText;
@property (strong, nonatomic) NSString *confirmText;

@property (strong, nonatomic) RACSignal *changePasswordHintSignal;

- (void)changePassword;


@end
