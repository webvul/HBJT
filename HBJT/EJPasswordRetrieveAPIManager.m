//
//  EJPasswordRetrieveAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/4/1.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJPasswordRetrieveAPIManager.h"

@implementation EJPasswordRetrieveAPIManager

- (instancetype)initWithUsername:(NSString *)usernameText newPassword:(NSString *)password phoneNumber:(NSString *)phoneNumber
{
    self = [super initWith:kEJSNetworkAPINameRetrievePassword];
    if (self) {
        [self.params setObject:usernameText forKey:@"username"];
        [self.params setObject:password forKey:@"newpassword"];
        [self.params setObject:phoneNumber forKey:@"phonenumber"];
    }
    return self;
}

@end
