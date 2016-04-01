//
//  EJProgressDetailAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/4/1.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJProgressDetailAPIManager.h"

@implementation EJProgressDetailAPIManager

- (instancetype)initWithID:(NSString *)itemID
{
    self = [super initWith:kEJSNetworkAPINameProgressInquiry];
    if (self) {
        [self.params setObject:itemID forKey:@"id"];
    }
    return self;
}

@end
