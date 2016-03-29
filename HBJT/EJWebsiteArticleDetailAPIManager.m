//
//  EJWebsiteArticleDetailAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/28.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJWebsiteArticleDetailAPIManager.h"

@implementation EJWebsiteArticleDetailAPIManager

- (instancetype)initWithArticleID:(NSString *)articleID
{
    self = [super initWith:kEJSNetworkAPINameWebsiteArticle];
    if (self) {
        [self.params setObject:articleID forKey:@"info_id"];
    }
    return self;
}

@end
