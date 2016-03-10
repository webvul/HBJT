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
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:usernameText forKey:@"username"];
        [params setObject:[EJSNetwork encryptedPassword:passwordText] forKey:@"password"];
        [params setObject:nameText forKey:@"realName"];
        [params setObject:numberText forKey:@"cardnum"];
        [params setObject:phoneText forKey:@"mobilephone"];
        [params setObject:addressText forKey:@"contractaddress"];
    }
    return self;
}

@end
