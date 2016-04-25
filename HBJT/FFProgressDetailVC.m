//
//  FFProgressDetailVC.m
//  HBJT
//
//  Created by fanggao on 16/4/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FFProgressDetailVC.h"
#import "EJResultDetailViewModel.h"
#import "UIViewController+BarItem.h"
#import "FFGuildCell.h"
#import "CommonTool.h"
#import "Masonry.h"
//获取屏幕宽度
#define FFScreenWidth [UIScreen mainScreen].bounds.size.width
//获取屏幕高度
#define FFScreenHeight [UIScreen mainScreen].bounds.size.height

@interface FFProgressDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) EJResultDetailViewModel *viewModel;
@property (nonatomic, strong) UITableView  * tableView ;
@property (nonatomic, strong) NSArray  * leftTitleArr ;

@end

@implementation FFProgressDetailVC

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView=[self returnTitle:@"细节详情"];
    
    [self.view addSubview:self.tableView];
    [self _setupConstraints];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_viewModel load];
}

#pragma mark - Methods
- (void)preparedWithSender:(id)sender
{
    if ([sender isKindOfClass:[NSDictionary class]]) {
        self.viewModel.resultType = [[sender objectForKey:@"type"] integerValue];
        self.viewModel.resultID = [sender objectForKey:@"id"];
    }
}

- (void)_setupConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(FFScreenWidth, FFScreenHeight));
    }];
}

- (void)bindViewModelForNotice
{
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            if ([x isEqualToString:@"事项获取成功"]) {
                [self.tableView reloadData];
            }
        }
    }];
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

- (EJResultDetailViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJResultDetailViewModel viewModel];
        [_viewModel connect];
        [self bindViewModel];
    }
    return _viewModel;
}

- (NSArray *)leftTitleArr
{
    return @[@"申请事项名称",@"提交时间",@"剩余时间",@"事项编号",@"提交人",@"当前状态",@"当前办理环节",@"受理时间",@"转入来源"];
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
        CGRect  rect = [CommonTool getHeightWithText:[self.viewModel.data objectForKey:@"resultName"] AndWidth:FFScreenWidth-120 AndFont:[UIFont systemFontOfSize:13.0f]];
        return rect.size.height + 20 ;
    }
    else if (indexPath.row == 4)
    {
        CGRect  rect = [CommonTool getHeightWithText:[self.viewModel.data objectForKey:@"resultProposer"] AndWidth:FFScreenWidth-120 AndFont:[UIFont systemFontOfSize:13.0f]];
        return rect.size.height + 20 ;
    }
    else
    {
        return 40 ;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFGuildCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if (!cell) {
        cell = [[FFGuildCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
    }
    cell.leftLabel.textAlignment = NSTextAlignmentRight ;
    cell.leftLabel.text = self.leftTitleArr[indexPath.row];
    
    cell.rightLabel.textColor = [UIColor grayColor];
    if (indexPath.row == 0)
    {
        cell.rightLabel.textColor = [UIColor blueColor];
        
        cell.rightLabel.text = [self.viewModel.data objectForKey:@"resultName"] ;
        CGRect  rect = [CommonTool getHeightWithText:[self.viewModel.data objectForKey:@"resultName"] AndWidth:FFScreenWidth-120 AndFont:[UIFont systemFontOfSize:13.0f]];
        [cell getCellHeight:rect.size.height+1];
    }
    else if (indexPath.row == 1)
    {
        NSString  * timeString = [self.viewModel.data objectForKey:@"resultSubmitDate"];
        NSString  * year = [[timeString componentsSeparatedByString:@","]lastObject];
        NSString  * time1 = [[timeString componentsSeparatedByString:@","]firstObject];
        NSString  * month = [[time1 componentsSeparatedByString:@" "]firstObject];
        NSString  * monthTure  ;
        if ([month isEqualToString:@"一月"])
        {
            monthTure = @"01";
        }
        else if ([month isEqualToString:@"二月"])
        {
            monthTure = @"02";
        }
        else if ([month isEqualToString:@"三月"])
        {
            monthTure = @"03";
        }
        else if ([month isEqualToString:@"四月"])
        {
            monthTure = @"04";
        }
        else if ([month isEqualToString:@"五月"])
        {
            monthTure = @"05";
        }
        else if ([month isEqualToString:@"六月"])
        {
            monthTure = @"06";
        }
        else if ([month isEqualToString:@"七月"])
        {
            monthTure = @"07";
        }
        else if ([month isEqualToString:@"八月"])
        {
            monthTure = @"08";
        }
        else if ([month isEqualToString:@"九月"])
        {
            monthTure = @"09";
        }
        else if ([month isEqualToString:@"十月"])
        {
            monthTure = @"10";
        }
        else if ([month isEqualToString:@"十一月"])
        {
            monthTure = @"11";
        }
        else if ([month isEqualToString:@"十二月"])
        {
            monthTure = @"12";
        }
        
        NSString  * day = [[time1 componentsSeparatedByString:@" "]lastObject];
        if (day.length == 1)
        {
            day = [NSString stringWithFormat:@"0%@",day];
        }
        cell.rightLabel.text = [NSString stringWithFormat:@"%@-%@-%@",year,monthTure,day];
        
    }
    else if (indexPath.row == 2)
    {
        cell.rightLabel.text = ([self.viewModel.data objectForKey:@"resultEstimateTime"]? [[[self.viewModel.data objectForKey:@"resultEstimateTime"] stringValue] stringByAppendingString:@"天"]: nil) ;
    }
    else if (indexPath.row == 3)
    {
        cell.rightLabel.text = [self.viewModel.data objectForKey:@"resultNumber"] ;
    }
    else if (indexPath.row == 4)
    {
        cell.rightLabel.text = [self.viewModel.data objectForKey:@"resultProposer"] ;
        CGRect  rect = [CommonTool getHeightWithText:[self.viewModel.data objectForKey:@"resultProposer"] AndWidth:FFScreenWidth-120 AndFont:[UIFont systemFontOfSize:13.0f]];
        [cell getCellHeight:rect.size.height+1];
    }
    else if (indexPath.row == 5 )
    {
        cell.rightLabel.text = [self.viewModel.data objectForKey:@"resultStep"];
    }
    else if (indexPath.row == 6)
    {
        cell.rightLabel.text = [self.viewModel.data objectForKey:@"result"] ;
    }
    else if (indexPath.row == 7)
    {
         NSString  * timeString = [self.viewModel.data objectForKey:@"resultAcceptDate"];
        NSString  * year = [[timeString componentsSeparatedByString:@","]lastObject];
        NSString  * time1 = [[timeString componentsSeparatedByString:@","]firstObject];
        NSString  * month = [[time1 componentsSeparatedByString:@" "]firstObject];
        NSString  * monthTure  ;
        if ([month isEqualToString:@"一月"])
        {
            monthTure = @"01";
        }
        else if ([month isEqualToString:@"二月"])
        {
            monthTure = @"02";
        }
        else if ([month isEqualToString:@"三月"])
        {
            monthTure = @"03";
        }
        else if ([month isEqualToString:@"四月"])
        {
            monthTure = @"04";
        }
        else if ([month isEqualToString:@"五月"])
        {
            monthTure = @"05";
        }
        else if ([month isEqualToString:@"六月"])
        {
            monthTure = @"06";
        }
        else if ([month isEqualToString:@"七月"])
        {
            monthTure = @"07";
        }
        else if ([month isEqualToString:@"八月"])
        {
            monthTure = @"08";
        }
        else if ([month isEqualToString:@"九月"])
        {
            monthTure = @"09";
        }
        else if ([month isEqualToString:@"十月"])
        {
            monthTure = @"10";
        }
        else if ([month isEqualToString:@"十一月"])
        {
            monthTure = @"11";
        }
        else if ([month isEqualToString:@"十二月"])
        {
            monthTure = @"12";
        }
        
        NSString  * day = [[time1 componentsSeparatedByString:@" "]lastObject];
        if (day.length == 1)
        {
            day = [NSString stringWithFormat:@"0%@",day];
        }
        cell.rightLabel.text = [NSString stringWithFormat:@"%@-%@-%@",year,monthTure,day];
    }
    else
    {
        cell.rightLabel.text = [self.viewModel.data objectForKey:@"resultResource"] ;
    }
    
    return cell ;
}

@end
