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
        [self modulate];
    }
    return self;
}

- (void)startWithSender:(id)sender
{
    
}

- (void)modulate
{

}

- (void)didReceiveMemoryWarning
{
    
}

- (void)dealloc
{
    NSLog(@"[%@ VIEWMODEL DEALLOCING]",self);
}


@end
