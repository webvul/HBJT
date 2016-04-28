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
    AppDelegate *delegate = [AppDelegate sharedDelegate];
    @weakify(delegate);
    self.currentUserSignal = [RACObserve([AppDelegate sharedDelegate], currentUser) map:^id(id value) {
        @strongify(delegate);
        if (![value boolValue]) {
            return value;
        }
        //NSString *name = [[AppDelegate sharedDelegate] userNameString];
        //return ([name isEqualToString:@"0"]?[delegate userUsernameString]: name);
        return [delegate userUsernameString];
    }];
}

@end


