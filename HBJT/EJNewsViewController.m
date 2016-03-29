//
//  EJSNewsViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/14.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJNewsViewController.h"
#import "EJNewsPictureTableViewCell.h"
#import "EJNewsTableViewCell.h"
#import "EJNewsViewModel.h"
#import "UIScrollView+HATFCarousel.h"

@interface EJNewsViewController ()

@property (strong, nonatomic) NSMutableArray *currentDataSource;
@property (strong, nonatomic) NSMutableArray *nextDataSource;
@property (strong, nonatomic) NSMutableArray *previousDataSource;
@property (strong, nonatomic) NSArray *buttonArray;
@property (strong, nonatomic) NSArray *labelArray;

@property (weak, nonatomic) IBOutlet UIScrollView *controlScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel0;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel1;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel2;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel3;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel4;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel5;
@property (weak, nonatomic) IBOutlet UITableView *tableView0;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (strong, nonatomic) EJNewsViewModel *viewModel;

@end

@implementation EJNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.buttonArray = @[self.button0,self.button1,self.button2,self.button3,self.button4,self.button5];
    self.labelArray = @[self.buttonLabel0,self.buttonLabel1,self.buttonLabel2,self.buttonLabel3,self.buttonLabel4,self.buttonLabel5];
    self.tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.viewModel reload];
    }];
    [self bindViewModel];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.mainScrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)clearCurrentDataSource
{
    [self.currentDataSource removeAllObjects];
    NSLog(@"%@",self.currentDataSource);
    [self.tableView1 reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    @weakify(self);
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self.mainScrollView buildCarousel:1 previousBlock:^(NSInteger index) {
        @strongify(self);
        self.nextDataSource = self.currentDataSource;
        [self clearCurrentDataSource];
        [self.tableView0 reloadData];
        [self.tableView2 reloadData];
        [self.viewModel loadPreviousTab];
        [self.tableView1.mj_header beginRefreshing];
    } nextBlock:^(NSInteger index) {
        @strongify(self);
        self.previousDataSource = self.currentDataSource;
        [self clearCurrentDataSource];
        [self.tableView0 reloadData];
        [self.tableView2 reloadData];
        [self.viewModel loadNextTab];
        [self.tableView1.mj_header beginRefreshing];
    }];
    [self.tableView1.mj_header beginRefreshing];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView1) {
        if (self.currentDataSource)
            if ([self.currentDataSource[indexPath.row] objectForKey:@"articleThumbnailURL"] != [NSNull null]) {
                return 110 + self.view.frame.size.width/2;
            }
    }
    return 101;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *newsTitle = [self.viewModel.data[indexPath.row] objectForKey:@"articleTitle"];
    NSString *newsID = [[self.viewModel.data[indexPath.row] objectForKey:@"articleID"] stringValue];
    NSString *newsDate = [self.viewModel.data[indexPath.row] objectForKey:@"articleTime"];
    NSString *newsRead = [[self.viewModel.data[indexPath.row] objectForKey:@"articleReadNumber"] stringValue];
    NSString *newsLaud = [[self.viewModel.data[indexPath.row] objectForKey:@"articleLaudNumber"] stringValue];

    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"News" bundle:nil] instantiateViewControllerWithIdentifier:@"Detail"];
    [self prepareViewController:viewController withSender:@{@"newsTitle":newsTitle,@"newsID":newsID,@"newsDate":newsDate,@"newsRead":newsRead,@"newsLaud":newsLaud}];
    [self.navigationController pushViewController:viewController animated:YES];
}
   
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.tableView0) {
        return self.previousDataSource.count;
        
    } else if (tableView == self.tableView1)
    {
        return self.currentDataSource.count;
    } else if (tableView == self.tableView2)
    {
        return self.nextDataSource.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * dataSource;
    if (tableView == self.tableView0) {
        dataSource = self.previousDataSource;
    } else if (tableView == self.tableView1)
    {
        dataSource = self.currentDataSource;
    } else if (tableView == self.tableView2)
    {
        dataSource = self.nextDataSource;
    }
    NSDictionary *articleData = dataSource[indexPath.row];
    if ([articleData objectForKey:@"articleThumbnailURL"] == [NSNull null]) {
        EJNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"news"];
        if (cell == nil) {
            cell = [[EJNewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"news"];
        }
        cell.titleLabel.text = [articleData objectForKey:@"articleTitle"];
        cell.markNewImageView.hidden = ![articleData objectForKey:@"articleIsNewTag"];
        cell.timeLabel.text = [articleData objectForKey:@"articleTime"];
        cell.readLabel.text = [[articleData objectForKey:@"articleReadNumber"]stringValue];
        cell.laudLabel.text = [[articleData objectForKey:@"articleLaudNumber"]stringValue];
        return cell;
    }
    else
    {
        EJNewsPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pictureNews"];
        if (cell == nil) {
            cell = [[EJNewsPictureTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pictureNews"];
        }
        cell.titleLabel.text = [articleData objectForKey:@"articleTitle"];
        cell.markNewImageView.hidden = ![articleData objectForKey:@"articleIsNewTag"];
        cell.timeLabel.text = [articleData objectForKey:@"articleTime"];
        cell.readLabel.text = [[articleData objectForKey:@"articleReadNumber"]stringValue];
        cell.laudLabel.text = [[articleData objectForKey:@"articleLaudNumber"]stringValue];
        [cell.thumbnailImageView sd_setImageWithURL:[articleData objectForKey:@"articleThumbnailURL"]];
        return cell;
    }
}

- (void)bindViewModelToUpdate
{
    NSInteger i = 0;
    @weakify(self);
    for (UIButton *button in self.buttonArray) {
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            self.viewModel.currentTabIndex = i;
            [self.tableView1.mj_header beginRefreshing];
            //[self.viewModel reload];
        }];
        i++;
    }
}

- (void)bindViewModelForNotice
{
    @weakify(self);
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        @strongify(self);
        if ([x isKindOfClass:[NSString class]]) {
            if ([x isEqualToString:@"读取成功"]) {
                self.currentDataSource = self.viewModel.data;
                //NSLog(@"%@,%@",self.currentDataSource,self.viewModel.data);
                [self.tableView1 reloadData];
            }
        } else
        {
            if (![x boolValue]) {
                [self.tableView1.mj_header endRefreshing];

            } else
            {

            }
        }
    }];
    
    [self.viewModel.tabNumberSiganl subscribeNext:^(id x) {
        NSInteger i = [x integerValue];
        [self.controlScrollView setContentOffset:CGPointMake((80*6 - self.view.frame.size.width)/5*i, 0) animated:YES];
        for (UILabel *buttonLabel in self.labelArray) {
            buttonLabel.hidden = YES;
        }
        UILabel *buttonLabel = self.labelArray[i];
        buttonLabel.hidden = NO;
    }];
}

- (void)preparedWithSender:(id)sender
{
    self.viewModel.currentTabIndex = [sender integerValue];
}

- (EJNewsViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJNewsViewModel viewModel];
        [_viewModel connect];
    }
    return _viewModel;
}

@end
