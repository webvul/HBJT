//
//  RegisterViewController.m
//  hbjt
//
//  Created by 方秋鸣 on 16/1/28.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJRegisterViewController.h"

@interface EJRegisterViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *agreeLabelButton;
@property (strong, nonatomic) IBOutlet UIButton *agreeButton;
@property (strong, nonatomic) EJRegisterViewModel *viewModel;
@property (strong, nonatomic) MBProgressHUD *hub;
@end

@implementation EJRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [FTKeyboardTapGestureRecognizer addRecognizerFor:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Reactive Methods

- (void)bindViewModelToUpdate
{
    RAC(self.viewModel, usernameText) = self.usernameTextField.rac_textSignal;
    RAC(self.viewModel, passwordText) = self.passwordTextField.rac_textSignal;
    RAC(self.viewModel, confirmText) = self.confirmTextField.rac_textSignal;
    RAC(self.viewModel, numberText) = self.numberTextField.rac_textSignal;
    RAC(self.viewModel, phoneText) = self.phoneTextField.rac_textSignal;
    RAC(self.viewModel, nameText) = self.nameTextField.rac_textSignal;
    RAC(self.viewModel, addressText) = self.addressTextField.rac_textSignal;
    @weakify(self);
    [[self.agreeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.viewModel.isUserAgreed = !self.viewModel.isUserAgreed;
    }];
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel registery];
    }];
}

- (void)bindViewModelForNotice
{
    [self.viewModel.userAgreedSingal subscribeNext:^(id x) {
        self.agreeLabelButton.imageView.image = [UIImage imageNamed:([x boolValue]?@"06.fw":@"05.fw")];
    }];
    [self.viewModel.registerHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            [self.hub setLabelText:x];
        } else if ([x boolValue]) {
            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.hub setYOffset:-64];
        } else {
            [self.hub hide:YES afterDelay:2];
        }
    }];
}

#pragma mark - Getter

- (EJRegisterViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJRegisterViewModel viewModel];
        [self bindViewModel];
    }
    return _viewModel;
}

@end
