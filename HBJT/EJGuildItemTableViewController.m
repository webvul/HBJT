//
//  EJGuildItemTableViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJGuildItemTableViewController.h"
#import "EJGuildItemViewModel.h"
#import "EJGuildItemTableViewCell.h"

@interface EJGuildItemTableViewController ()

@property (nonatomic, strong) EJGuildItemViewModel *viewModel;
@property (nonatomic, strong) MBProgressHUD *hub;


@end

@implementation EJGuildItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewModel loadItemList];
    // Do any additional setup after loading the view.
}

- (void)preparedWithSender:(id)sender
{
    if ([sender isKindOfClass:[NSString class]]) {
        self.viewModel.primaryItemIDString = sender;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
                NSLog(@"%@",self.tableView);
                [self.tableView reloadData];
            }
            else
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

- (EJGuildItemViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJGuildItemViewModel viewModel];
        [self bindViewModel];
        [_viewModel connect];
    }
    return _viewModel;
}

@end
