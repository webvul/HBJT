//
//  EJModifyUserinfoViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/10.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJModifyUserinfoViewController.h"
#import "EJModifyUserinfoViewModel.h"
#import "AppDelegate.h"

@interface EJModifyUserinfoViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (strong, nonatomic) IBOutlet UIButton *modifyUserinfoButton;
@property (strong, nonatomic) MBProgressHUD *hub;
@property (strong, nonatomic) EJModifyUserinfoViewModel *viewModel;

@end

@implementation EJModifyUserinfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView=[self returnTitle:@"个人资料"];
    
    [FTKeyboardTapGestureRecognizer addRecognizerFor:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewModel];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self.addressTextView setContentOffset:CGPointMake(0, 0) animated:NO];
    [super viewDidAppear:animated];

}

#pragma mark - Reactive Method

- (void)bindViewModelForNotice
{
    /*RAC(self.usernameTextField, placeholder) = [self.viewModel.usernamePlaceHolderSiganal replayLast];
    RAC(self.nameTextField, placeholder) = [self.viewModel.namePlaceHolderSiganal replayLast];
    RAC(self.numberTextField, placeholder) = [self.viewModel.numberPlaceHolderSiganal replayLast];
    RAC(self.phoneTextField, placeholder) = [self.viewModel.phonePlaceHolderSiganal replayLast];
    RAC(self.addressTextField, placeholder) = [self.viewModel.addressPlaceHolderSiganal replayLast];*/
    @weakify(self);
    [self.viewModel.modifyUserinfoHintSignal subscribeNext:^(id x) {
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
    [[[[[self.viewModel.modifyUserinfoHintSignal filter:^BOOL(id value) {
        return [value isKindOfClass:[NSString class]];
    }] filter:^BOOL(id value) {
        return [value isEqualToString:@"修改成功"];
    }] doNext:^(id x) {
//        @strongify(self);
//        self.nameTextField.text = @"";
//        self.numberTextField.text = @"";
//        self.phoneTextField.text = @"";
//        self.addressTextField.text = @"";
    }] delay:1.0] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)bindViewModelToUpdate
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    self.usernameTextField.text = appDelegate.userUsernameString;
    self.nameTextField.text = appDelegate.userNameString;
    self.numberTextField.text = appDelegate.userNumberString;
    self.phoneTextField.text = appDelegate.userPhoneString;
    self.addressTextView.text = appDelegate.userAddressString;
    self.addressTextView.showsVerticalScrollIndicator = NO;
    RAC(self.viewModel, nameText) = self.nameTextField.rac_textSignal;
    RAC(self.viewModel, numberText) = self.numberTextField.rac_textSignal;
    RAC(self.viewModel, phoneText) = self.phoneTextField.rac_textSignal;
    RAC(self.viewModel, addressText) = self.addressTextView.rac_textSignal;
    [[self.modifyUserinfoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel modifyUserinfo];
    }];
}

- (EJModifyUserinfoViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJModifyUserinfoViewModel viewModel];
        [self.viewModel connect];
        [self bindViewModel];
    }
    return _viewModel;
}


@end
