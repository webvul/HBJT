//
//  EJLoginAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/4.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJLoginAPIManager.h"

@implementation EJLoginAPIManager


- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWith:kEJSNetworkAPINameLogin params:params];
    return self;
}

@end
