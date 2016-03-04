//
//  FTViewModel.m
//  FTools
//
//  Created by 方秋鸣 on 16/2/22.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTViewModel.h"

@implementation FTViewModel

+ (instancetype)viewModel
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self start];
    }
    return self;
}

- (void)start
{
    
}

- (void)connect
{
    self.isConnected = YES;
}

- (void)disconnect
{
    self.isConnected = NO;
}

- (void)stop
{
    [self disconnect];
}

- (void)dealloc
{
    NSLog(@"%@ VIEWMODEL DEALLOCING",[self class]);
}


@end
