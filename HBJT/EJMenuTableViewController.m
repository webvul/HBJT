//
//  EJMenuTableViewController.m
//  hbjt
//
//  Created by 方秋鸣 on 16/1/19.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJMenuTableViewController.h"
#import "AppDelegate.h"

@interface EJMenuTableViewController ()
@property (strong, nonatomic) IBOutlet UIButton *usernameLabel;
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
@end

@implementation EJMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLayoutConstraint];
    [self prepareOtherViewController];

}

- (void)createLayoutConstraint
{
    //self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGFLOAT_MIN)];
    self.tableView.contentInset = UIEdgeInsetsMake(-36.0f, 0.0f, 0.0f, 0.0f);
    if (self.view.frame.size.height > 500)
    {
        self.tableView.scrollEnabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{

    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
             
             
             [[[AppDelegate sharedDelegate] rootNavigationController] pushViewController:[[UIStoryboard storyboardWithName:@"Index" bundle:nil] instantiateInitialViewController] animated:YES];
             NSLog(@"1");
    // [self pushMenuControllerNamed:@"section" inStoryboardNamed:@"Matters"];
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
#pragma - private methods




- (void)prepareOtherViewController
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    @weakify(appDelegate);
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(appDelegate);
        [[appDelegate drawerController] closeDrawerAnimated:YES completion:nil];
        [[appDelegate rootNavigationController] pushViewController:[[UIStoryboard storyboardWithName:@"Logger" bundle:nil]instantiateInitialViewController] animated:YES];
    }];

}


/*- (void)bindViewModel
 {
 self.viewModel = [[MenuTableViewModel alloc]init];
 [self bindMenuButton:self.loginButton toControllerNamed:@"login" inStoryboardNamed:@"Logger"];
 RAC(self.loginLabelButton, hidden) = self.viewModel.didloginSignal;
 RAC(self.usernameLabel, hidden) = self.viewModel.didlogoutSignal;
 RAC(self.logoutCell, hidden) = self.viewModel.didlogoutSignal;
 }
 - (void)bindMenuButton:(UIButton *)button
 toControllerNamed:(NSString *)controllerName
 inStoryboardNamed:(NSString *)storyboardName;
 {
 @weakify(self);
 [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
 @strongify(self);
 [self pushMenuControllerNamed:controllerName inStoryboardNamed:storyboardName];
 }];
 }
 
 - (void)pushMenuControllerNamed:(NSString *)controllerName
 inStoryboardNamed:(NSString *)storyboardName;
 {
 //[self.sideMenuViewController hideMenuViewController];
 self.EJIndexViewController.isNeedShowMenu = YES;
 @weakify(self);
 [[[RACSignal empty] delay:0] subscribeCompleted:^{
 @strongify(self);
 
 }];
 }*/


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
