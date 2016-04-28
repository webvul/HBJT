//
//  EJFollowViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/4/13.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFollowViewController.h"
#import "EJFollowViewModel.h"
#import "FFDoSomethingGuildVC.h"

@interface EJFollowViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) EJFollowViewModel *viewModel;
@property (strong, nonatomic) MBProgressHUD *hub;

@end

@implementation EJFollowViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel fetchList];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self returnBack];
    self.navigationItem.titleView=[self returnTitle:@"我的关注"];
    [self bindViewModel];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuserID = @"Follow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuserID];
    }
    cell.textLabel.text = [[self.viewModel.itemList[indexPath.row] objectForKey:@"iteminfo"] objectForKey:@"itemname"];
    cell.detailTextLabel.text = @"";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.itemList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFDoSomethingGuildVC  * viewController = [[FFDoSomethingGuildVC alloc]init];
    [self prepareViewController:viewController withSender:[self.viewModel.itemList[indexPath.row] objectForKey:@"iteminfoid"]];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)bindViewModelForNotice
{
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            if ([x isEqualToString:@"获取成功"]) {
                [self.tableView reloadData];
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

- (EJFollowViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJFollowViewModel viewModel];
    }
    return _viewModel;
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




@end
