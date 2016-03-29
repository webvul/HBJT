//
//  EJWebsiteArticleLaudAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/28.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJWebsiteArticleLaudAPIManager.h"

@implementation EJWebsiteArticleLaudAPIManager

- (instancetype)initWithArticleID:(NSString *)articleID
{
    self = [super initWith:kEJSNetworkAPINameWebsiteSaveLaud];
    if (self) {
        [self.params setObject:articleID forKey:@"info_id"];
        [self.params setObject:[EJSNetwork uuid] forKey:@"laudHardware"];
    }
    return self;
}

@end
