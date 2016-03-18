//
//  EJChangePasswordAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/10.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJChangePasswordAPIManager.h"

@implementation EJChangePasswordAPIManager

- (instancetype)initWithID:(NSString *)userIDString newPassword:(NSString *)newPasswordText
{
    self = [super initWith:kEJSNetworkAPINameChangePasswd];
    if (self) {
        [self.params setObject:userIDString forKey:@"userid"];
        [self.params setObject:newPasswordText forKey:@"newpassword"];
    }
    return self;
}

@end
