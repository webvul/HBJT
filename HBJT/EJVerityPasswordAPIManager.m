//
//  EJVerityPasswordAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/10.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJVerityPasswordAPIManager.h"

@implementation EJVerityPasswordAPIManager

- (instancetype)initWithID:(NSString *)userIDString password:(NSString *)oldPasswordText
{
    self = [super initWith:kEJSNetworkAPINameVerityPasswd];
    if (self) {
        [self.params setObject:userIDString forKey:@"userid"];
        [self.params setObject:oldPasswordText forKey:@"oldpassword"];
    }
    return self;
}

@end
