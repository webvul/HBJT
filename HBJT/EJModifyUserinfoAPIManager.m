//
//  EJModifyUserinfoAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/10.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJModifyUserinfoAPIManager.h"

@implementation EJModifyUserinfoAPIManager

- (instancetype)initWithID:(NSString *)userIDString name:(NSString *)nameText number:(NSString *)numberText phone:(NSString *)phoneText address:(NSString *)addressText
{
    self = [super initWith:kEJSNetworkAPINameModifyUserinfo];
    if (self) {
        [self.params setObject:userIDString forKey:@"id"];
        [self.params setObject:nameText forKey:@"realName"];
        [self.params setObject:numberText forKey:@"carenum"];
        [self.params setObject:phoneText forKey:@"mobilephone"];
        [self.params setObject:addressText forKey:@"contractaddress"];
    }
    return self;
}
@end
