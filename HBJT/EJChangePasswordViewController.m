//
//  EJChangePasswordViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/10.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJChangePasswordViewController.h"
#import "EJChangePasswordViewModel.h"

@interface EJChangePasswordViewController ()
@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmTextField;
@property (strong, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (strong, nonatomic) MBProgressHUD *hub;
@property (strong, nonatomic) EJChangePasswordViewModel* viewModel;

@end

@implementation EJChangePasswordViewController

- (void)viewDidLoad
{
    [FTKeyboardTapGestureRecognizer addRecognizerFor:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel connect];
}

- (void)bindViewModelToUpdate
{
    RAC(self.viewModel, oldpasswordText) = [self.oldPasswordTextField rac_textSignal];
    RAC(self.viewModel, passwordText) = [self.passwordTextField rac_textSignal];
    RAC(self.viewModel, confirmText) = [self.confirmTextField rac_textSignal];
    @weakify(self);
    [[self.changePasswordButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel changePassword];
    }];
}

- (void)bindViewModelForNotice
{
    @weakify(self);
    [self.viewModel.changePasswordHintSignal subscribeNext:^(id x) {
        @strongify(self);
        if ([x isKindOfClass:[NSString class]]) {
            [self.hub setLabelText:x];
        } else if ([x boolValue]) {
            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.hub setYOffset:0];
        } else {
            [self.hub hide:YES afterDelay:1];
        }
    }];
}

- (void)prepareOtherViewController
{
    @weakify(self);
    [[[[self.viewModel.changePasswordHintSignal filter:^BOOL(id value) {
        return [value isKindOfClass:[NSString class]];
    }] filter:^BOOL(id value) {
        return [value isEqualToString:@"密码修改成功"];
    }] delay:1] subscribeNext:^(id x) {
        @strongify(self);
        self.oldPasswordTextField.text = @"";
        self.passwordTextField.text = @"";
        self.confirmTextField.text = @"";
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (EJChangePasswordViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJChangePasswordViewModel viewModel];
        [self bindViewModel];
    }
    return _viewModel;
}
@end
