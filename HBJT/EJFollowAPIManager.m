//
//  EJFollowAPIManger.m
//  HBJT
//
//  Created by 方秋鸣 on 16/4/22.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFollowAPIManager.h"

@implementation EJFollowAPIManager

- (instancetype)initWithUserID:(NSString *)userID itemID:(NSString *)itemID
{
    self = [super initWith:kEJSNetworkAPINameFollow];
    if (self) {
        [self.params setObject:userID forKey:@"userid"];
        [self.params setObject:itemID forKey:@"itemID"];
    }
    return self;
}

@end
