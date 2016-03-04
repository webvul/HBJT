//
//  LoginViewController.m
//  hbjt
//
//  Created by 方秋鸣 on 16/1/20.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJLoginTableViewController.h"
#import "AppDelegate.h"

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
}

- (void)loginSuccessed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel connect];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [self.viewModel stop];
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
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
            [self.hub hide:YES afterDelay:2];
        }
    }];

}

- (void)prepareOtherViewController
{
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
