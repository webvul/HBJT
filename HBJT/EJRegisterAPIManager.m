//
//  EJRegisterAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/4.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJRegisterAPIManager.h"
#import "EJS.h"

@implementation EJRegisterAPIManager

- (instancetype)initWithUsername:(NSString *)usernameText password:(NSString *)passwordText name:(NSString *)nameText number:(NSString *)numberText phone:(NSString *)phoneText address:(NSString *)addressText
{
    self = [super initWith:kEJSNetworkAPINameRegister];
    if (self) {
        [self.params setObject:usernameText forKey:@"username"];
        [self.params setObject:passwordText forKey:@"password"];
        [self.params setObject:nameText forKey:@"realName"];
        [self.params setObject:numberText forKey:@"cardnum"];
        [self.params setObject:phoneText forKey:@"mobilephone"];
        [self.params setObject:addressText forKey:@"contractaddress"];
    }
    return self;
}

@end
