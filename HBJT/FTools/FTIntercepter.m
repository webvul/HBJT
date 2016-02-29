//
//  FTIntercepter.m
//  ftools
//
//  Created by 方秋鸣 on 16/1/8.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTIntercepter.h"
#import <Aspects/Aspects.h>
#import <UIKit/UIKit.h>

@implementation FTIntercepter

+ (void)load
{
    [super load];
    [FTIntercepter sharedInstance];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static FTIntercepter *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FTIntercepter alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [UIViewController aspect_hookSelector:@selector(loadView) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            [self loadView:[aspectInfo instance]];
        } error:NULL];
        
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
            [self viewWillAppear:animated viewController:[aspectInfo instance]];
        } error:NULL];
    }
    return self;
}

#pragma mark - fake methods
- (void)loadView:(UIViewController *)viewController
{
    NSLog(@"[%@ loadView]", [viewController class]);
}

- (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController
{
    NSLog(@"[%@ viewWillAppear:%@]", [viewController class], animated ? @"YES" : @"NO");
}

@end