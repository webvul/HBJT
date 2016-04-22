//
//  EJFollowViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/4/13.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFollowViewController.h"
#import "EJFollowViewModel.h"

@interface EJFollowViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) EJFollowViewModel *viewModel;
@property (strong, nonatomic) MBProgressHUD *hub;

@end

@implementation EJFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self.viewModel fetchList];
    [self returnBack];
    self.navigationItem.titleView=[self returnTitle:@"我的关注"];
    // Do any additional setup after loading the view.
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
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Guild" bundle:nil] instantiateViewControllerWithIdentifier:@"Detail"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
