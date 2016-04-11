//
//  EJPasswordRetrieveViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/29.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJPasswordRetrieveViewController.h"
#import "EJPasswordRetrieveViewModel.h"

@interface EJPasswordRetrieveViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *smsSenderButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *passwordRetrieveButton;

@property (strong, nonatomic) EJPasswordRetrieveViewModel *viewModel;
@property (strong, nonatomic) MBProgressHUD *hub;

@end

@implementation EJPasswordRetrieveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self returnBack];
    self.navigationItem.titleView=[self returnTitle:@"忘记密码"];
    // Do any additional setup after loading the view.
    [self bindViewModel];
}

- (void)bindViewModelToUpdate
{
    RAC(self.viewModel, usernameText) = self.usernameTextField.rac_textSignal;
    RAC(self.viewModel, phoneNumberText) = self.phoneNumberTextField.rac_textSignal;
    RAC(self.viewModel, codeText) = self.smsCodeTextField.rac_textSignal;
    RAC(self.viewModel, passwordText) = self.passwordTextField.rac_textSignal;
    RAC(self.viewModel, repeatPasswordText) = self.confirmTextField.rac_textSignal;
    [[self.smsSenderButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self.viewModel verifyPhone];
    }];
    [[self.passwordRetrieveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self.viewModel retrievePassword];
    }];
}

- (void)bindViewModelForNotice
{
    @weakify(self);
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (EJPasswordRetrieveViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJPasswordRetrieveViewModel viewModel];
        [_viewModel connect];
    }
    return _viewModel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
