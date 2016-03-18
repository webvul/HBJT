//
//  EJLoginAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/4.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJLoginAPIManager.h"

@implementation EJLoginAPIManager


- (instancetype)initWithUsername:(NSString *)usernameText password:(NSString *)password
{
    self = [super initWith:kEJSNetworkAPINameLogin];
    if (self) {
        [self.params setObject:usernameText forKey:@"username"];
        [self.params setObject:[EJSNetwork encryptedPassword:password] forKey:@"password"];
    }
    return self;
}

@end
