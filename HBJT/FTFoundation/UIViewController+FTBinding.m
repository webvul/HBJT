//
//  UIViewController+FTBinding.m
//  FTools
//
//  Created by 方秋鸣 on 16/3/2.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "UIViewController+FTBinding.h"

static void *viewModelKey = &viewModelKey;

@implementation UIViewController (FTBinding)

-(void)setViewModel:(FTViewModel *)viewModel
{
    objc_setAssociatedObject(self, & viewModelKey, viewModel, OBJC_ASSOCIATION_COPY);
}

-(FTViewModel *)viewModel
{
    return objc_getAssociatedObject(self, &viewModelKey);
}

- (void)bindViewModel
{
    [self bindViewModelToUpdate];
    [self bindViewModelForNotice];
}

- (void)bindViewModelToUpdate
{
    
}

- (void)bindViewModelForNotice
{
    
}

- (void)prepareOtherViewController
{
    
}

- (void)preparedWithSender:(__nullable id)sender
{
    
}

- (void)prepareViewController:(nonnull UIViewController *)viewContorller withSender:(__nullable id)sender
{
    [viewContorller preparedWithSender:sender];
    [self.navigationController pushViewController:viewContorller animated:YES];
}

@end
