//
//  EJUserAgreementViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/9.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJUserAgreementViewController.h"
#import "EJFramework.h"

@interface EJUserAgreementViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation EJUserAgreementViewController

- (void)viewDidLoad
{
    [self.textView setTextContainerInset:UIEdgeInsetsMake(0, 15, 0, 15)];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.textView setContentOffset: CGPointMake(0,-64) animated:NO];
}

@end
