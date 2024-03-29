//
//  EJGuildViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/22.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#define SystemVersionLessThan(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#import "EJGuildViewController.h"
#import "EJGuildViewModel.h"
#import "EJGuildPrimaryItemTableViewController.h"
#import "EJGuildResultTableViewCell.h"
#import "FFProgressDetailVC.h"
@interface EJGuildViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tabLabel0;
@property (weak, nonatomic) IBOutlet UIButton *tabButton0;
@property (weak, nonatomic) IBOutlet UILabel *tabLabel2;
@property (weak, nonatomic) IBOutlet UIButton *tabButton1;
@property (weak, nonatomic) IBOutlet UILabel *tabLabel1;
@property (weak, nonatomic) IBOutlet UIButton *tabButton2;
@property (weak, nonatomic) IBOutlet UIView *guildView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *locateButton;
@property (weak, nonatomic) IBOutlet UIButton *switchCityButton;
@property (weak, nonatomic) IBOutlet UIScrollView *areaScrollView;
@property (weak, nonatomic) IBOutlet UIView *areaScrollContentView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *districtButtonArray;
@property (strong, nonatomic) NSMutableArray *sectionButtonArray;
@property (strong, nonatomic) MBProgressHUD *hub;
@property (strong, nonatomic) EJGuildViewModel *viewModel;
@property (assign, nonatomic) NSInteger retryTime;

@property (nonatomic, strong) FFProgressDetailVC  * viewController ;
@property (nonatomic, assign) NSInteger  row ;

@end

@implementation EJGuildViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView=[self returnTitle:@"行政审批"];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.viewModel loadMore];
    }];
    self.viewModel = [EJGuildViewModel viewModel];
    [self bindViewModel];
    [self.viewModel connect];
    [self.viewModel loadAreaList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.retryTime = 0;
}

- (void)loadAreaScrollView
{
    for (UIButton *button in self.districtButtonArray) {
        [button removeFromSuperview];
    }
    self.districtButtonArray = [[NSMutableArray alloc]init];
    NSInteger i = 0;
    for (NSDictionary *areaInfo in self.viewModel.districtArray) {
        UIButton *districtButton = [[[NSBundle mainBundle] loadNibNamed:@"GuildDistrictButton" owner:self options:nil] firstObject];
        [self.areaScrollContentView addSubview:districtButton];
        NSString *title = [areaInfo objectForKey:@"areaName"];
        [districtButton setTitle:(title.length>4?[title substringToIndex:4]:title) forState:UIControlStateNormal];
        [districtButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.areaScrollContentView);
            if (self.districtButtonArray.count == 0) {
                make.leading.equalTo(self.areaScrollContentView).offset(10);
            }
            else
            {
                make.leading.equalTo([(UIButton *)self.districtButtonArray.lastObject trailing]).offset(22);
            }
            make.size.mas_equalTo(CGSizeMake(28, 85));
        }];
        [self.districtButtonArray addObject:districtButton];
        [[districtButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            self.viewModel.currentDistrictIndex = i;
        }];
        i ++;
    }
    [self.districtButtonArray.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.areaScrollContentView).offset(-10);
    }];
}

// 武汉市交通运输局 
- (void)loadSectionButtons
{
    for (UIButton *button in self.sectionButtonArray) {
        [button removeFromSuperview];
    }
    NSInteger i = 0;
    self.sectionButtonArray = [[NSMutableArray alloc] init];
    if (self.viewModel.sectionArray.count > 0) {
        for (NSDictionary *sectionInfo in self.viewModel.sectionArray) {
            UIButton *sectionButton = [[[NSBundle mainBundle] loadNibNamed:@"GuildSectionButton" owner:self options:nil] firstObject];
            [self.guildView addSubview:sectionButton];
            [sectionButton setTitle:[sectionInfo objectForKey:@"itemname"] forState:UIControlStateNormal];
            [sectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.guildView).offset(25);
                make.trailing.equalTo(self.guildView).offset(-25);
                make.width.equalTo(sectionButton.height).multipliedBy(60/7);
                if (self.sectionButtonArray.count == 0) {
                    make.top.equalTo(self.areaScrollView.bottom).offset(27);
                }
                else
                {
                    make.top.equalTo([(UIButton *)self.sectionButtonArray.lastObject bottom]).offset(20);
                }
            }];
            // 武汉市交通运输局 按钮点击事情
            [[sectionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                EJGuildPrimaryItemTableViewController *primaryItemViewController = [[UIStoryboard storyboardWithName:@"Guild" bundle:nil] instantiateViewControllerWithIdentifier:@"PrimaryItem"];
                primaryItemViewController.titleName = [sectionInfo objectForKey:@"itemname"];
                [self prepareViewController:primaryItemViewController withSender:[self.viewModel.sectionArray[i] objectForKey:@"id"]];
                [self.navigationController pushViewController:primaryItemViewController animated:YES];
            }];
            [self.sectionButtonArray addObject:sectionButton];
            i++;
        }
        [self.guildView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo([(UIButton *)self.sectionButtonArray.lastObject bottom]).offset(27);
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _viewController = [[FFProgressDetailVC alloc]init];
    if (self.row == 2)
    {
        _viewController.titleName = @"进度查询";
    }
    if (self.row == 3)
    {
        _viewController.titleName = @"结果公示";
    }
    NSString *itemID = [self.viewModel.resultArray[indexPath.row] objectForKey:@"id"];
    NSNumber *resultType = @(self.viewModel.currentTab);
    [self prepareViewController:_viewController withSender:@{@"id":itemID,@"type":resultType}];
    [self.navigationController pushViewController:_viewController animated:YES];
}
    
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIScrollView *scrollView = (UIScrollView *)self.guildView.superview;
    if (self.sectionButtonArray.count > 0) {
        scrollView.scrollEnabled = (((UIButton *)self.sectionButtonArray.lastObject).frame.origin.y > self.guildView.frame.size.height - 34 - 27);
    }
    else
    {
        scrollView.scrollEnabled = NO;
    }
    if (SystemVersionLessThan(@"8.0")) {
        scrollView.scrollEnabled = YES;
    }
    if (!scrollView.scrollEnabled)
    {
        [scrollView setContentOffset:(CGPoint){0,0} animated:YES];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tabLabel1.hidden)
    {
        EJGuildResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[EJGuildResultTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"ResultCell"];
        }
        cell.titleButton.text = [self.viewModel.resultArray[indexPath.row] objectForKey:@"extItemname"];
        cell.subtitleButton.text = [self.viewModel.resultArray[indexPath.row] objectForKey:@"extCode"];
        cell.resultLabel.text = [self.viewModel.resultArray[indexPath.row] objectForKey:@"completeStatus"];
        cell.resultLabel.hidden = !cell.resultLabel.text.length;
        return cell;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [self.viewModel.resultArray[indexPath.row] objectForKey:@"extItemname"];
    cell.detailTextLabel.text = [self.viewModel.resultArray[indexPath.row] objectForKey:@"extCode"];
    return cell;
}

- (void)bindViewModelToUpdate
{
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            if ([x isEqualToString:@"区域信息读取成功"]) {
                self.cityLabel.text = [self.viewModel.cityArray[self.viewModel.currentCityIndex] objectForKey:@"areaName"];
                [self loadAreaScrollView];
            }
            else if ([x isEqualToString:@"正在获取区域信息"])
            {
                
            }
            else if ([x isEqualToString:@"部门信息读取成功"])
            {
                [self loadSectionButtons];
            }
            else if ([x isEqualToString:@"事项获取成功"])
            {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
            else
            {
                if (self.viewModel.cityArray == nil && self.guildView.hidden == NO)
                {
                    self.retryTime ++;
                    if (self.retryTime <= 2) {
                        [self.viewModel loadAreaList];
                    }
                }
                [self.tableView.mj_header endRefreshing];
            }

        }
    }];

    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            [self.hub setLabelText:x];
        } else if ([x boolValue]) {
            self.hub = [MBProgressHUD showHUDAddedTo:self.guildView animated:YES];
            [self.hub setYOffset:-40];
        } else {
            [self.hub hide:YES];
        }
    }];
}

- (void)bindViewModelForNotice
{
    @weakify(self);
    
    [[self.switchCityButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.viewModel.cityArray != nil) {
            if (SystemVersionLessThan(@"8.0")) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择所在区域" message:@"\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                for (NSDictionary *cityInfo in self.viewModel.cityArray) {
                    [alert addButtonWithTitle:[cityInfo objectForKey:@"areaName"]];
                }
                [alert show];
                
            }
            else
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请选择所在区域"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                NSInteger i = 0;
                for (NSDictionary *cityInfo in self.viewModel.cityArray) {
                    UIAlertAction* cityAction = [UIAlertAction actionWithTitle:[cityInfo objectForKey:@"areaName"] style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction * action) {
                                                                           @strongify(self);
                                                                           self.viewModel.currentCityIndex = i;
                                                                           self.cityLabel.text = [self.viewModel.cityArray[self.viewModel.currentCityIndex] objectForKey:@"areaName"];
                                                                           [self loadAreaScrollView];
                                                                       }];
                    [alert addAction:cityAction];
                    i ++;
                }
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }];
    
    // 上面的3个按钮点击事件
    [[self.tabButton0 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.guildView.hidden = NO;
        self.tabLabel0.hidden = NO;
        self.tabLabel1.hidden = YES;
        self.tabLabel2.hidden = YES;
        [self.tableView.mj_header endRefreshing];
    }];
    [[self.tabButton1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        self.row = 2 ;
        
        self.guildView.hidden = YES;
        self.tabLabel0.hidden = YES;
        self.tabLabel1.hidden = NO;
        self.tabLabel2.hidden = YES;
        self.viewModel.currentTab = 0;
        [self.viewModel loadNew];
    }];
    [[self.tabButton2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        self.row = 3 ;
        
        self.guildView.hidden = YES;
        self.tabLabel0.hidden = YES;
        self.tabLabel1.hidden = YES;
        self.tabLabel2.hidden = NO;
        self.viewModel.currentTab = 1;
        [self.viewModel loadNew];
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.viewModel.currentCityIndex = buttonIndex - 1;
    self.cityLabel.text = [self.viewModel.cityArray[self.viewModel.currentCityIndex] objectForKey:@"areaName"];
    [self loadAreaScrollView];
}

@end
