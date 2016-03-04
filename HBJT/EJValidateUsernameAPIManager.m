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

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWith:kEJSNetworkAPINameValidateUsername params:params];
    return self;
}

@end
