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
        [self autoStart];
    }
    return self;
}

- (void)autoStart
{
    
}

- (void)start
{
    NSAssert(YES, @"必须同时重写start和stop方法");
    [self stop];
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
    NSAssert(YES, @"必须同时重写start和stop方法");
    [self start];
}

- (void)dealloc
{
    NSLog(@"%@ VIEWMODEL DEALLOCING",[self class]);
}

- (RACSignal *)networkHintSignal
{
    if (_networkHintSignal == nil) {
        _networkHintSignal = [[RACObserve(self, isNetworkProceed) merge:RACObserve(self, networkHintText)] filter:^BOOL(id value) {
            return _isConnected;
        }];
    }
    return _networkHintSignal;
}


@end
