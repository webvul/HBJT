//
//  EJValidateUsernameAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/4.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJValidateUsernameAPIManager.h"
#import "EJS.h"

@implementation EJValidateUsernameAPIManager

- (instancetype)initWithUsername:(NSString *)usernameText
{
    self = [super initWith:kEJSNetworkAPINameValidateUsername];
    if (self) {
        [self.params setObject:usernameText forKey:@"username"];
    }
    return self;
}

@end
