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
@property (strong, nonatomic) IBOutlet UIButton *agreedLabelButton;
@property (strong, nonatomic) IBOutlet UIButton *agreeButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) EJRegisterViewModel *viewModel;
@property (strong, nonatomic) MBProgressHUD *hub;
@end

@implementation EJRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bind];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)bind
{
    if (self.viewModel == nil) {
        self.viewModel = [EJRegisterViewModel viewModel];
    }
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel registery];
    }];
    RAC(self.viewModel, usernameText) = RACObserve(self.usernameTextField, text);
    RAC(self.viewModel, passwordText) = RACObserve(self.passwordTextField, text);
    RAC(self.viewModel, numberText) = RACObserve(self.numberTextField, text);
    RAC(self.viewModel, phoneText) = RACObserve(self.phoneTextField, text);
    RAC(self.viewModel, nameText) = RACObserve(self.nameTextField, text);
    RAC(self.viewModel, addressText) = RACObserve(self.addressTextField, text);
    [[self.viewModel.registerHintSignal distinctUntilChanged] subscribeNext:^(id x) {
        if (x) {
            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        } else {
            [self.hub hide:YES afterDelay:2];
        }
    }];
    RAC(self, hub.labelText) = self.viewModel.registerHintSignal;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}


@end
