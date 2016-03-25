//
//  EJItemInfoAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/24.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJItemInfoAPIManager.h"

@implementation EJItemInfoAPIManager

- (instancetype)initWIthItemID:(NSString *)itemID
{
    self = [super initWith:kEJSNetworkAPINameQueryItemInfo];
    if (self) {
        [self.params setObject:itemID forKey:@"id"];
    }
    return self;
}


@end
