//
//  EJSuggestionViewModel.m
//  HBJT
//
//  Created by Davina on 16/3/14.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJSuggestionViewModel.h"
#import "EJSuggestionAPIManager.h"

@interface EJSuggestionViewModel ()

@property (strong, nonatomic)EJSuggestionAPIManager *suggestionAPIManager;
@property (strong, nonatomic)RACSignal *suggestSignal;

@end

@implementation EJSuggestionViewModel

- (void)autoStart
{
    self.suggestSignal = [self createSignalForAPIManager:self.suggestionAPIManager];
}

- (void)suggest
{
    [self subscribeNetworkSignal:self.suggestSignal apiManger:self.suggestionAPIManager];
}

@end
