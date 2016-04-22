//
//  EJFollowListAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/4/13.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFollowListAPIManager.h"

@implementation EJFollowListAPIManager

- (instancetype)initWithUserID:(NSString *)userID pageNumber:(NSNumber *)pageNumber
{
    self = [super initWith:kEJSNetworkAPINameFollowList];
    if (self) {
        [self.params setObject:userID forKey:@"userid"];
        [self.params setObject:@(15) forKey:@"pageSize"];
        [self.params setObject:pageNumber forKey:@"pageNumber"];
    }
    return self;
}

@end
