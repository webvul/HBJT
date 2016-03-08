//
//  FTKeyboardTapGestureRecognizer.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/7.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTKeyboardTapGestureRecognizer.h"

@implementation FTKeyboardTapGestureRecognizer

+ (void)addRecognizerFor:(UIView *)view
{
    [view addGestureRecognizer:[[self alloc]init]];
}

+ (instancetype)recognizer
{
    return [[self alloc]init];
}

- (instancetype)init
{
    self = [super initWithTarget:self action:@selector(hideKeyboard)];
    if (self) {
        self.cancelsTouchesInView = NO;
        self.delaysTouchesEnded = NO;
        self.delegate = self;
    }
    return self;
}
            
- (void)hideKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

# pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end

