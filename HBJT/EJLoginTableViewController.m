//
//  LoginViewController.m
//  hbjt
//
//  Created by 方秋鸣 on 16/1/20.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJLoginTableViewController.h"
#import "AppDelegate.h"
#import "EJFramework.h"
#import "EJLoginViewModel.h"

@interface EJLoginTableViewController ()
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIView *usernameCell;
@property (weak, nonatomic) IBOutlet UIView *passwordCell;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) MBProgressHUD *hub;
@property (strong, nonatomic) EJLoginViewModel *viewModel;

@end

@implementation EJLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [FTKeyboardTapGestureRecognizer addRecognizerFor:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel connect];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self prepareOtherViewController];
    });
}

- (void)didReceiveMemoryWarning {
    self.viewModel = nil;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Reactive Method

- (void)bindViewModelToUpdate
{
    RAC(self.viewModel, usernameText) = self.usernameTextField.rac_textSignal;
    RAC(self.viewModel, passwordText) = self.passwordTextField.rac_textSignal;
    @weakify(self);
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel login];
    }];
}

- (void)bindViewModelForNotice
{
    [self.viewModel.loginTintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            [self.hub setLabelText:x];
        } else if ([x boolValue]) {
            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.hub setYOffset:-64];
        } else {
            [self.hub hide:YES afterDelay:1];
        }
    }];
}

- (void)prepareOtherViewController
{
    [[[[self.viewModel.loginTintSignal filter:^BOOL(id value) {
        return [value isKindOfClass:[NSString class]];
    }] filter:^BOOL(id value) {
        return [value isEqualToString:@"登录成功"];
    }] delay:1] subscribeNext:^(id x) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)preparedWithSender:(id)sender
{
    if ([sender isKindOfClass:[NSArray class]]) {
        NSArray *array = sender;
        self.viewModel.usernameText = [array firstObject];
        self.viewModel.passwordText = [array lastObject];
        [self.viewModel connect];
        [self.viewModel login];
    }
}

#pragma mark - Getter

- (EJLoginViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJLoginViewModel viewModel];
        [self bindViewModel];
    }
    return _viewModel;
}

@end
