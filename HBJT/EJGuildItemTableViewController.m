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

@property (strong, nonatomic) IBOutlet UILabel *mainLabel;
@property (nonatomic, strong) EJGuildItemViewModel *viewModel;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (strong, nonatomic) NSString *labelTitle;


@end

@implementation EJGuildItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self returnBack];
    [self.viewModel loadItemList];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView=[self returnTitle:@"办事指南"];
    self.mainLabel.text = self.labelTitle;
}

- (void)preparedWithSender:(id)sender
{
    if ([sender isKindOfClass:[NSDictionary class]]) {
        self.viewModel.primaryItemIDString = [sender objectForKey:@"id"];
        self.labelTitle = [NSString stringWithFormat:@"  %@",[sender objectForKey:@"name"]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Guild" bundle:nil] instantiateViewControllerWithIdentifier:@"Detail"];
    [self prepareViewController:viewController withSender:[self.viewModel.itemList[indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:viewController animated:YES];
}


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

- (void)bindViewModelForNotice
{
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            if ([x isEqualToString:@"事项获取成功"]) {
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
