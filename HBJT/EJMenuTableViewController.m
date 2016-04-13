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
@property (weak, nonatomic) IBOutlet UIButton *letterButton;
@property (weak, nonatomic) IBOutlet UIButton *surveyButton;

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
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    if (indexPath.section == 1) {
        if ([appDelegate currentUser] == NO) {
            [appDelegate closeDrawerNeedReopen:NO];
            [appDelegate push:[[UIStoryboard storyboardWithName:@"Logger" bundle:nil]instantiateInitialViewController]];
        } else {
            switch (indexPath.row) {
                case 0:
                    [appDelegate closeDrawerNeedReopen:YES];
                    [appDelegate push:[[UIStoryboard storyboardWithName:@"Matter" bundle:nil] instantiateInitialViewController]];
                    break;
                case 1:
                    [appDelegate closeDrawerNeedReopen:YES];
                    [appDelegate push:[[UIStoryboard storyboardWithName:@"Matter" bundle:nil] instantiateViewControllerWithIdentifier:@"matter"]];
                    break;
            }
        }
    }
    if (indexPath.section ==2) {
        switch (indexPath.row) {
            case 0:
                [appDelegate closeDrawerNeedReopen:YES];
                [appDelegate push:[[UIStoryboard storyboardWithName:@"Suggestion" bundle:nil] instantiateInitialViewController]];
                break;
                
            default:
                break;
        }
    }
    if (indexPath.section == 3) {
        if ([appDelegate currentUser] == NO) {
            [appDelegate closeDrawerNeedReopen:NO];
            [appDelegate push:[[UIStoryboard storyboardWithName:@"Logger" bundle:nil]instantiateInitialViewController]];
        }
        else
        {
            switch (indexPath.row) {
                case 0:
                    [appDelegate closeDrawerNeedReopen:YES];
                    [appDelegate push:[[UIStoryboard storyboardWithName:@"Userinfo" bundle:nil] instantiateInitialViewController]];
                    break;
                case 1:
                    [appDelegate closeDrawerNeedReopen:YES];
                    [appDelegate push:[[UIStoryboard storyboardWithName:@"Userinfo" bundle:nil] instantiateViewControllerWithIdentifier:@"password"]];
                    break;
                case 2:
                    [appDelegate setCurrentUser:NO];
                    break;
                default:
                    break;
            }
        }
    }
    
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
    [[self.letterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(appDelegate);
        [appDelegate closeDrawerNeedReopen:YES];
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Suggestion" bundle:nil]instantiateInitialViewController];
        [self prepareViewController:viewController withSender:@(1)];
        [appDelegate push:viewController];
    }];
    [[self.surveyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(appDelegate);
        [appDelegate closeDrawerNeedReopen:YES];
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Index" bundle:nil]instantiateViewControllerWithIdentifier:@"Web"];
        NSString *url = [[EJSNetwork urlList] objectForKey:kEJSNetworkAPINameSurvey];
        [self prepareViewController:viewController withSender:@{@"title":@"在线调查",@"url":url,@"offset":@(-50-64)}];
        [appDelegate push:viewController];
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
            self.logoutCell.hidden = NO;
        } else if (![x boolValue])
        {
            self.usernameLabelButton.hidden = YES;
            self.loginLabelButton.hidden = NO;
            self.loginButton.enabled = YES;
            [self.usernameLabelButton setTitle:@"" forState:UIControlStateNormal];
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
