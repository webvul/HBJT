//
//  EJItemAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/24.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJItemAPIManager.h"

@implementation EJItemAPIManager

- (instancetype)initWIthPrimaryItemID:(NSString *)itemID
{
    self = [super initWith:kEJSNetworkAPINameQueryPrimaryItem];
    if (self) {
        [self.params setObject:itemID forKey:@"id"];
    }
    return self;
}

@end
