//
//  FFDoSomethingGuildVC.m
//  HBJT
//
//  Created by fanggao on 16/4/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FFDoSomethingGuildVC.h"
#import "EJFramework.h"
#import "EJGuildItemDetailViewModel.h"
#import "UIViewController+BarItem.h"
#import "FFGuildCell.h"
#import "CommonTool.h"
#import "AppDelegate.h"

//获取屏幕宽度
#define FFScreenWidth [UIScreen mainScreen].bounds.size.width
//获取屏幕高度
#define FFScreenHeight [UIScreen mainScreen].bounds.size.height

@interface FFDoSomethingGuildVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView  * tableView ;
@property (strong, nonatomic) EJGuildItemDetailViewModel *viewModel;
@property (nonatomic, strong) NSArray  * leftTitleArr ;
@property (nonatomic, strong) UIView  * detailView ;
@property (nonatomic, strong) MBProgressHUD *hub;

@end

@implementation FFDoSomethingGuildVC

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView=[self returnTitle:@"办事指南"];
    [self rightBtntitle:@"关注" withimage:@"04"];
    
    [self.view addSubview:self.tableView];
    [self _setupConstraints];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_viewModel loadItemInfo];
}

#pragma mark - Methods
-(void)rightBtntitle:(NSString *)title withimage:(NSString *)imagename{
    
    //选择时间的按钮
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(0, 0, 90, 30);
    //先设置按钮里面的内容居中
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //设置文字居左 －>向左移15(左减右加)
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    //设置图片居右 －>向右移20
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [rightButton setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:size5];
    
    [rightButton setTitle:title forState:UIControlStateNormal];
    
    UIBarButtonItem *addnewBtn=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[AppDelegate sharedDelegate] currentUser]? [self.viewModel follow]: [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Logger" bundle:nil] instantiateInitialViewController] animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = addnewBtn;
}

- (void)_setupConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(FFScreenWidth, FFScreenHeight-49));
    }];
}

- (void)bindViewModelForNotice
{
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            if ([x isEqualToString:@"读取成功"]) {
                [self.tableView reloadData];
            }
        }
    }];
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            [self.hub setLabelText:x];
            if ([x isEqualToString:@"读取成功"]||[x isEqualToString:@"关注成功"]||[x isEqualToString:@"取消成功"]) {
                (self.viewModel.followed? [self rightBtntitle:@"取消关注" withimage:@"004"]: [self rightBtntitle:@"关注" withimage:@"04"]);
            }
        } else if ([x boolValue]) {
            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //[self.hub setYOffset:-64];
        } else {
            [self.hub hide:YES afterDelay:1];
        }
    }];

}

// 点击查看详情
- (void)ViewWithTitle:(NSString *)title AndContent:(NSString *)content
{
    _detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FFScreenWidth, FFScreenHeight)];
    _detailView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    [self.view.window addSubview:_detailView];
    
    UIView  * aView = [[UIView alloc]initWithFrame:CGRectMake(20, 64, FFScreenWidth-40, FFScreenHeight-64)];
    aView.backgroundColor = [UIColor whiteColor];
    [_detailView addSubview:aView];
    
    UILabel  * titleLabel = [[UILabel alloc]init];
    titleLabel.text = title ;
    titleLabel.textAlignment = NSTextAlignmentCenter ;
    [aView addSubview:titleLabel];
    
    UIWebView  * webView = [[UIWebView alloc]init];
    webView.layer.borderWidth = 0.5 ;
    webView.layer.borderColor = [[UIColor grayColor]CGColor];
    [webView loadHTMLString:content baseURL:nil];
    [aView addSubview:webView];
    
    UIButton  * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:sureButton];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(aView.centerX);
        make.top.equalTo(aView.top).with.offset(10.0f);
        make.width.equalTo(aView.width);
        make.height.mas_equalTo(20);
    }];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.bottom).with.offset(10.0f);
        make.width.equalTo(aView.width);
        make.bottom.equalTo(sureButton.top);
        make.centerX.equalTo(aView.centerX);
    }];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aView.bottom).with.offset(-40.0f);
        make.width.equalTo(aView.width);
        make.height.mas_equalTo(40);
        make.centerX.equalTo(aView.centerX);
    }];
}

- (void)sureButton:(UIButton *)btn
{
    [_detailView removeFromSuperview];
    [_detailView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)preparedWithSender:(id)sender
{
    if ([sender isKindOfClass:[NSString class]]) {
        self.viewModel.itemID = sender;
    }
}

#pragma mark - Getters
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self ;
        _tableView.showsVerticalScrollIndicator = NO ;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    }
    return _tableView ;
}

- (EJGuildItemDetailViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJGuildItemDetailViewModel viewModel];
        [_viewModel connect];
        [self bindViewModel];
    }
    return _viewModel;
}

- (NSArray *)leftTitleArr
{
    return @[@"项目审批名称",@"项目设定机关",@"实施机关名称",@"承办机关名称",@"协办机关名称",@"法律法规依据",@"审批范围和条件",@"申请材料",@"受理地点",@"咨询电话",@"投诉电话"];
}

#pragma mark - UITableView  Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leftTitleArr.count ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        CGRect  rect = [CommonTool getHeightWithText:self.viewModel.itemName AndWidth:FFScreenWidth-120 AndFont:[UIFont systemFontOfSize:13.0f]];
        return rect.size.height + 20 ;
    }
    else
    {
        return 40 ;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFGuildCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[FFGuildCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.leftLabel.text = self.leftTitleArr[indexPath.row];

    cell.rightLabel.textColor = [UIColor grayColor];
    if (indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7)
    {
       cell.rightLabel.textColor = [UIColor blueColor];
    }
    
    if (indexPath.row == 0)
    {
        cell.rightLabel.text = self.viewModel.itemName ;
        CGRect  rect = [CommonTool getHeightWithText:self.viewModel.itemName AndWidth:FFScreenWidth-120 AndFont:[UIFont systemFontOfSize:13.0f]];
        [cell getCellHeight:rect.size.height+1];
    }
    else if (indexPath.row == 1)
    {
        cell.rightLabel.text = self.viewModel.itemSetupOffice ;
    }
    else if (indexPath.row == 2)
    {
        cell.rightLabel.text = self.viewModel.itemImplementOffice ;
    }
    else if (indexPath.row == 3)
    {
        cell.rightLabel.text = self.viewModel.itemUndertakeOffice ;
    }
    else if (indexPath.row == 4)
    {
        cell.rightLabel.text = self.viewModel.itemParticipateOffice ;
    }
    else if (indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7)
    {
        cell.rightLabel.text = @"【点击查看详情】" ;
    }

    else if (indexPath.row == 8)
    {
        cell.rightLabel.text = self.viewModel.itemLocation ;
    }
    else if (indexPath.row == 9)
    {
        cell.rightLabel.text = self.viewModel.itemConsultation ;
    }
    else
    {
        cell.rightLabel.text = self.viewModel.itemComplaint ;
    }
    
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5)
    {
        [self ViewWithTitle:@"法律法规依据" AndContent:self.viewModel.itemLegal];
    }
    else if (indexPath.row == 6)
    {
        [self ViewWithTitle:@"审批范围和条件" AndContent:self.viewModel.itemTerm];
    }
    else if (indexPath.row == 7)
    {
        [self ViewWithTitle:@"审批材料" AndContent:self.viewModel.itemDocument];
    }
}




@end
