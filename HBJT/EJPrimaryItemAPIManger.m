//
//  EJPrimaryItemAPIManger.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/24.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJPrimaryItemAPIManger.h"

@implementation EJPrimaryItemAPIManger

- (instancetype)initWithSectionID:(NSString *)sectionID
{
    self = [super initWith:kEJSNetworkAPINameQueryPrimaryItem];
    if (self) {
        [self.params setObject:sectionID forKey:@"id"];
    }
    return self;
}

@end
