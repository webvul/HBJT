//
//  EJModifyUserinfoViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/10.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJModifyUserinfoViewController.h"
#import "EJModifyUserinfoViewModel.h"

@interface EJModifyUserinfoViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UIButton *modifyUserinfoButton;
@property (strong, nonatomic) MBProgressHUD *hub;
@property (strong, nonatomic) EJModifyUserinfoViewModel *viewModel;

@end

@implementation EJModifyUserinfoViewController

- (void)viewDidLoad
{
    [FTKeyboardTapGestureRecognizer addRecognizerFor:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel connect];
}

#pragma mark - Reactive Method

- (void)bindViewModelForNotice
{
    RAC(self.usernameTextField, placeholder) = self.viewModel.usernamePlaceHolderSiganal;
    RAC(self.nameTextField, placeholder) = self.viewModel.namePlaceHolderSiganal;
    RAC(self.numberTextField, placeholder) = self.viewModel.numberPlaceHolderSiganal;
    RAC(self.phoneTextField, placeholder) = self.viewModel.phonePlaceHolderSiganal;
    RAC(self.addressTextField, placeholder) = self.viewModel.addressPlaceHolderSiganal;
    [self.viewModel.modifyUserinfoHintSignal subscribeNext:^(id x) {
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

- (void)bindViewModelToUpdate
{
    RAC(self.viewModel, nameText) = self.nameTextField.rac_textSignal;
    RAC(self.viewModel, numberText) = self.numberTextField.rac_textSignal;
    RAC(self.viewModel, phoneText) = self.phoneTextField.rac_textSignal;
    RAC(self.viewModel, addressText) = self.addressTextField.rac_textSignal;
    [[self.modifyUserinfoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel modifyUserinfo];
    }];
}


- (EJModifyUserinfoViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJModifyUserinfoViewModel viewModel];
        [self bindViewModel];
    }
    return _viewModel;
}


@end
