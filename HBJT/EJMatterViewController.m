//
//  EJMatterViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/10.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJMatterViewController.h"
#import "EJMatterViewModel.h"


@interface EJMatterViewController ()


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MBProgressHUD *hub;
@property (strong, nonatomic) EJMatterViewModel *viewModel;
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *dataSource;

@end

@implementation EJMatterViewController

- (void)viewDidLoad
{
    [self returnBack];
    
    [self bindViewModel];
    //[self createLayoutConstraints];
}

- (void)createLayoutConstraints
{
    [self.tableView.mj_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    //self.dataSource = @[@{@"matterTitle":@"12"},@{@"matterTitle":@"11112"},@{@"matterTitle":@"122"}];
    [self.viewModel connect];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"matter"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"matter"];
    }
    cell.textLabel.text = [self.dataSource[indexPath.row] objectForKey:@"matterTitle"];
    return cell;
}


#pragma mark - Reactive Method

- (void)bindViewModelToUpdate
{
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel queryFirst];
    }];
}

- (void)bindViewModelForNotice
{
    @weakify(self);
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        @strongify(self);
        if (![x isKindOfClass:[NSString class]]) {
            if (![x boolValue]) {
                @strongify(self);
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }
        }
    }];
}

- (void)preparedWithSender:(id)sender
{
    if ([sender isKindOfClass:[NSNumber class]]) {
        self.viewModel.section = [sender integerValue];
        
        NSArray *titleArray = @[@"我的草稿件",@"我的待审件",@"我的受理件",@"我的退回件",@"我的已办件",@"我的评议件"];
        self.navigationItem.titleView=[self returnTitle:titleArray[[sender integerValue]]];
        
    }
}

- (EJMatterViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJMatterViewModel viewModel];
    }
    return _viewModel;
    
}

@end
