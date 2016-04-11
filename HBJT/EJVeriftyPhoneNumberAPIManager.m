//
//  EJVeriftyPhoneNumberAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/4/1.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJVeriftyPhoneNumberAPIManager.h"

@implementation EJVeriftyPhoneNumberAPIManager

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber
{
    self = [super initWith:kEJSNetworkAPINameRetrievePassword];
    if (self) {
        [self.params setObject:phoneNumber forKey:@"phonenumber"];
    }
    return self;
}

@end
