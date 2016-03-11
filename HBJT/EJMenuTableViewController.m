//
//  EJMenuTableViewController.m
//  hbjt
//
//  Created by 方秋鸣 on 16/1/19.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJMenuTableViewController.h"
#import "AppDelegate.h"
#import "EJS/EJS.h"
#import "EJFramework.h"
#import "EJMenuViewModel.h"

@interface EJMenuTableViewController ()
@property (strong, nonatomic) IBOutlet UIButton *usernameLabelButton;
@property (strong, nonatomic) IBOutlet UIButton *loginLabelButton;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *matterCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *followCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *surveyCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *suggestionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *agreeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *userinfoCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *passwordCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *logoutCell;

@property (strong, nonatomic) EJMenuViewModel *viewModel;
@end

@implementation EJMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLayoutConstraint];
}

- (void)createLayoutConstraint
{
    self.tableView.contentInset = UIEdgeInsetsMake(-36.0f, 0.0f, 0.0f, 0.0f);
    if (self.view.frame.size.height > 500)
    {
        self.tableView.scrollEnabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel connect];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self prepareOtherViewController];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.viewModel disconnect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.viewModel = nil;
}

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    return ([[UITableViewHeaderFooterView alloc]init]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return self.view.frame.size.width *0.75;
    }
    return 38;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [[AppDelegate sharedDelegate] closeDrawerNeedReopen:YES];
                [[AppDelegate sharedDelegate] push:[[UIStoryboard storyboardWithName:@"Matter" bundle:nil] instantiateInitialViewController]];
                break;
        }
    }
    if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
                [[AppDelegate sharedDelegate] closeDrawerNeedReopen:YES];
                [[AppDelegate sharedDelegate] push:[[UIStoryboard storyboardWithName:@"Userinfo" bundle:nil] instantiateInitialViewController]];
                break;
            case 1:
                [[AppDelegate sharedDelegate] closeDrawerNeedReopen:YES];
                [[AppDelegate sharedDelegate] push:[[UIStoryboard storyboardWithName:@"Userinfo" bundle:nil] instantiateViewControllerWithIdentifier:@"password"]];
                break;
            case 2:
                [[AppDelegate sharedDelegate] setCurrentUser:NO];
                break;
            default:
                break;
        }
    }
    // case 1:
     /*
     break;
     default:
     break;
     }
     }
     if (indexPath.section == 2) {
     switch (indexPath.row) {
     case 0:
     [self pushMenuControllerNamed:@"suggestion" inStoryboardNamed:@"Suggestion"];
     break;
     case 1:
     [self pushMenuControllerNamed:@"survey" inStoryboardNamed:@"Suggestion"];
     break;
     case 2:
     [self pushMenuControllerNamed:@"agree" inStoryboardNamed:@"Logger"];
     break;
     default:
     break;
     }
     }
     if (indexPath.section == 3) {
     switch (indexPath.row) {
     case 0:
     [self pushMenuControllerNamed:@"userinfo" inStoryboardNamed:@"Userinfo"];
     break;
     case 1:
     [self pushMenuControllerNamed:@"password" inStoryboardNamed:@"Userinfo"];
     break;
     default:
     break;
     }
     }*/
    
}
#pragma - Reactive methods

- (void)prepareOtherViewController
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    @weakify(appDelegate);
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(appDelegate);
        [appDelegate closeDrawerNeedReopen:NO];
        [appDelegate push:[[UIStoryboard storyboardWithName:@"Logger" bundle:nil]instantiateInitialViewController]];
    }];
}

- (void)bindViewModelForNotice
{
    [self.viewModel.currentUserSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            self.usernameLabelButton.hidden = NO;
            self.loginLabelButton.hidden = YES;
            self.loginButton.enabled = NO;
            [self.usernameLabelButton setTitle:x forState:UIControlStateNormal];
            self.passwordCell.hidden = NO;
            self.userinfoCell.hidden = NO;
            self.logoutCell.hidden = NO;
        } else if (![x boolValue])
        {
            self.usernameLabelButton.hidden = YES;
            self.loginLabelButton.hidden = NO;
            self.loginButton.enabled = YES;
            [self.usernameLabelButton setTitle:@"" forState:UIControlStateNormal];
            self.passwordCell.hidden = YES;
            self.userinfoCell.hidden = YES;
            self.logoutCell.hidden = YES;
        }
    }];
}

#pragma mark - Getter

- (EJMenuViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJMenuViewModel viewModel];
        [self bindViewModel];
    }
    return _viewModel;
}

@end
