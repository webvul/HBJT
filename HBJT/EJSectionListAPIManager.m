//
//  EJSectionListAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/24.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJSectionListAPIManager.h"

@implementation EJSectionListAPIManager

- (instancetype)initWithAreaCode:(NSString *)areaCode
{
    self = [super initWith:kEJSNetworkAPINameQueryDepartment];
    if (self) {
        [self.params setObject:areaCode forKey:@"areaCode"];
    }
    return self;
}

@end
