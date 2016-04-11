//
//  EJPasswordRetrieveViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/29.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"

@interface EJPasswordRetrieveViewModel : FTViewModel

@property (nonatomic, strong) NSString *usernameText;
@property (nonatomic, strong) NSString *phoneNumberText;
@property (nonatomic, strong) NSString *passwordText;
@property (nonatomic, strong) NSString *repeatPasswordText;
@property (strong, nonatomic) NSString *codeText;


- (void)verifyPhone;
- (void)retrievePassword;

@end
