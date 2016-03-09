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

- (instancetype)initWithParams:(NSDictionary *)params
{
    [params setValue:[EJSNetwork encryptedPassword:[params objectForKey:@"password"]]  forKey:@"password"];
    self = [super initWith:kEJSNetworkAPINameRegister params:params];
    return self;
}

@end
