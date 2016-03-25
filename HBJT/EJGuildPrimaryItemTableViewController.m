//
//  EJGuildPrimaryItemTableViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJGuildPrimaryItemTableViewController.h"
#import "EJGuildPrimaryItemViewModel.h"
#import "EJGuildItemTableViewCell.h"
#import "EJGuildItemTableViewController.h"

@interface EJGuildPrimaryItemTableViewController ()

@property (nonatomic, strong) EJGuildPrimaryItemViewModel *viewModel;
@property (nonatomic, strong) MBProgressHUD *hub;

@end

@implementation EJGuildPrimaryItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.viewModel loadItemList];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%@",self.viewModel.itemList);
    return self.viewModel.itemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EJGuildItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[EJGuildItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Item"];
    }
    cell.titleLabel.text = [self.viewModel.itemList[indexPath.row] objectForKey:@"itemname"];
    //cell.subLabel.text = [self.viewModel.itemList[indexPath.row] objectForKey:@""];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EJGuildItemTableViewController *tableViewController = [[UIStoryboard storyboardWithName:@"Guild" bundle:nil] instantiateViewControllerWithIdentifier:@"Item"];
    [self prepareViewController:tableViewController withSender:[self.viewModel.itemList[indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (void)bindViewModelForNotice
{
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            if ([x isEqualToString:@"事项获取成功"]) {
                [self.tableView reloadData];
            } else
            {
                [self.viewModel loadItemList];
            }
        }
    }];
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            [self.hub setLabelText:x];
        } else if ([x boolValue]) {
            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //[self.hub setYOffset:-64];
        } else {
            [self.hub hide:YES afterDelay:1];
        }
    }];
}

- (void)preparedWithSender:(id)sender
{
    NSLog(@"%@",sender);
    if ([sender isKindOfClass:[NSString class]]) {
        self.viewModel.sectionID = sender;
    }
    
}

- (EJGuildPrimaryItemViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJGuildPrimaryItemViewModel viewModel];
        [self bindViewModel];
        [_viewModel connect];
    }
    return _viewModel;
}

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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
