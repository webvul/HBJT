//
//  RegisterViewController.m
//  hbjt
//
//  Created by 方秋鸣 on 16/1/28.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJRegisterViewController.h"
#import "EJFramework.h"
#import "EJRegisterViewModel.h"
#import "EJLoginTableViewController.h"

@interface EJRegisterViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *agreeLabelButton;
@property (strong, nonatomic) IBOutlet UIButton *agreeButton;
@property (strong, nonatomic) EJRegisterViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) MBProgressHUD *hub;
@property (strong, nonatomic) UILabel *label;
@end

@implementation EJRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self returnTitle:@"用户注册"];

    [FTKeyboardTapGestureRecognizer addRecognizerFor:self.view];
    self.label = [[UILabel alloc] init];
    self.label.text = @"请输入联系地址";
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.22];
    self.label.font = [UIFont systemFontOfSize:14];
    [self.addressTextView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTextView.mas_top).with.offset(5.0f);
        make.left.equalTo(self.addressTextView.mas_left).with.offset(5.0f);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width -30, 26));
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel connect];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@",self.registerButton);    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 105)];



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
    RAC(self.viewModel, addressText) = self.addressTextView.rac_textSignal;
    @weakify(self);
    [[self.agreeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.viewModel.isUserAgreed = !self.viewModel.isUserAgreed;
    }];
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel registery];
    }];
    [[self.addressTextView rac_textSignal] subscribeNext:^(id x) {
        self.label.text = ([x isEqualToString:@""]? @"请输入联系地址":  @"");
    }];

}
- (IBAction)registerButtonClicked:(id)sender {
    [self.viewModel registery];
}

- (void)bindViewModelForNotice
{
    [self.viewModel.userAgreedSingal subscribeNext:^(id x) {
        self.agreeLabelButton.imageView.image = [UIImage imageNamed:([x boolValue]?@"06":@"05")];
    }];
    [self.viewModel.registerHintSignal subscribeNext:^(id x) {
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
    [[[[self.viewModel.registerHintSignal filter:^BOOL(id value) {
        return [value isKindOfClass:[NSString class]];
    }] filter:^BOOL(id value) {
        return [value isEqualToString:@"注册成功"];
    }] delay:1] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        [self prepareViewController:self.navigationController.topViewController withSender:@[self.viewModel.usernameText,self.viewModel.passwordText]];
    }];
}

#pragma mark - Getter

- (EJRegisterViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJRegisterViewModel viewModel];
        [self bindViewModel];
        [self prepareOtherViewController];
    }
    return _viewModel;
}

@end
