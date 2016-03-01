//
//  EJViewModel.m
//  hbjt
//
//  Created by 方秋鸣 on 16/2/22.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJViewModel.h"

@implementation EJViewModel

+ (instancetype)viewModel
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self start];
        [self modulate];
    }
    return self;
}

- (void)start
{
    
}

- (void)modulate
{

}

- (void)dealloc
{
    NSLog(@"[%@ VIEWMODEL DEALLOC]",self);
}


@end
