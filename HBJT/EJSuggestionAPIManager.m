//
//  EJSuggestionAPIManager.m
//  HBJT
//
//  Created by Davina on 16/3/14.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJSuggestionAPIManager.h"

@implementation EJSuggestionAPIManager

- (instancetype)initWithSuggestion:(NSString *)suggestionText
{
    self = [super initWith:kEJSNetworkAPINameSuggest];
    if (self) {
        [self.params setObject:suggestionText forKey:@"content"];
    }
    return self;
}

@end
