//
//  EJResultsListAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/29.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJResultsListAPIManager.h"

@implementation EJResultsListAPIManager

- (instancetype)initWithPageNumber:(NSInteger)pageNumber;
{
    self = [super initWith:kEJSNetworkAPINameResultsList];
    if (self) {
        [self.params setObject:@"15" forKey:@"pageSize"];
        [self.params setObject:@(pageNumber) forKey:@"pageNumber"];
    }
    return self;
}

@end
