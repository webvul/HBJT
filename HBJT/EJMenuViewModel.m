//
//  EJMenuViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/9.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJMenuViewModel.h"
#import "AppDelegate.h"

@implementation EJMenuViewModel

- (void)autoStart
{
    self.currentUserSignal = [RACObserve([AppDelegate sharedDelegate], currentUser) map:^id(id value) {
        if (![value boolValue]) {
            return value;
        }
        return [[AppDelegate sharedDelegate] usernameString];
    }];
}

@end


