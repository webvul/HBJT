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
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
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
    
    [self returnBack];
    self.navigationItem.titleView=[self returnTitle:@"登录"];
    
    // Do any additional setup after loading the view.
    [FTKeyboardTapGestureRecognizer addRecognizerFor:self.view];
}

-(void)returnBack{
    UIButton *leftBackBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBackBtn.frame=CGRectMake(0, 0, 50, 44);
    leftBackBtn.backgroundColor=[UIColor clearColor];
    
    UIImageView *sizeTitleImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"02.fw"]];
    sizeTitleImg.frame=CGRectMake(5,10 ,24,24);
    [leftBackBtn  addSubview:sizeTitleImg];

    
    [leftBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBackBtn];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarButtonItem];
}

-(UILabel *)returnTitle:(NSString *)title{
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLab.font=[UIFont systemFontOfSize:20.0f];
    titleLab.backgroundColor=[UIColor clearColor];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    titleLab.text=title;
    return titleLab;
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Logger" bundle:nil] instantiateViewControllerWithIdentifier:@"Register" ] animated:YES];
    }];
    [[self.forgetButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Logger" bundle:nil] instantiateViewControllerWithIdentifier:@"Forget" ] animated:YES];
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
        [self prepareOtherViewController];
    }
    return _viewModel;
}

@end
