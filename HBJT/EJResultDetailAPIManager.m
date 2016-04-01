//
//  EJResultDetailAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/4/1.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJResultDetailAPIManager.h"

@implementation EJResultDetailAPIManager

- (instancetype)initWithID:(NSString *)itemID
{
    self = [super initWith:kEJSNetworkAPINameResults];
    if (self) {
        [self.params setObject:itemID forKey:@"id"];
    }
    return self;
}

@end
