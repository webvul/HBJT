//
//  EJGuildItemDetailViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/28.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJGuildItemDetailViewController.h"
#import "EJGuildItemDetailViewModel.h"
#import "UIViewController+BarItem.h"
//获取屏幕宽度
#define FFScreenWidth [UIScreen mainScreen].bounds.size.width
//获取屏幕高度
#define FFScreenHeight [UIScreen mainScreen].bounds.size.height

@interface EJGuildItemDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemSetupOfficeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemImplementOfficeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemUndertakeOfficeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemParticipateOfficeLabel;
@property (weak, nonatomic) IBOutlet UIButton *itemLegalLabel;
@property (weak, nonatomic) IBOutlet UIButton *itemTermLabel;
@property (weak, nonatomic) IBOutlet UIButton *itemDocumentLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemConsultationLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemComplaintLabel;

@property (strong, nonatomic) MBProgressHUD *hub;
@property (strong, nonatomic) EJGuildItemDetailViewModel *viewModel;
@property (nonatomic, strong) UIView  * detailView ;

@end

@implementation EJGuildItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView=[self returnTitle:@"办事指南"];
    [self rightBtntitle:@"关注" withimage:@"04"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_viewModel loadItemInfo];
}


- (void)bindViewModelForNotice
{
    RAC(self, itemNameLabel.text) = RACObserve(self.viewModel, itemName);
    RAC(self, itemSetupOfficeLabel.text) = RACObserve(self.viewModel, itemSetupOffice);
    RAC(self, itemImplementOfficeLabel.text) = RACObserve(self.viewModel, itemImplementOffice);
    RAC(self, itemUndertakeOfficeLabel.text) = RACObserve(self.viewModel, itemUndertakeOffice);
    RAC(self, itemParticipateOfficeLabel.text) = RACObserve(self.viewModel, itemParticipateOffice);
    
    
    
    
    /*[RACObserve(self.viewModel, itemLegal) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [RACObserve(self.viewModel, itemTerm) subscribeNext:^(id x) {
        
    }];
    [RACObserve(self.viewModel, itemDocument) subscribeNext:^(id x) {
        
    }];*/
    
    RAC(self, itemLocationLabel.text) = RACObserve(self.viewModel, itemLocation);
    RAC(self, itemConsultationLabel.text) = RACObserve(self.viewModel, itemConsultation);
    RAC(self, itemComplaintLabel.text) = RACObserve(self.viewModel, itemComplaint);
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
    if ([sender isKindOfClass:[NSString class]]) {
        self.viewModel.itemID = sender;
    }
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

-(void)rightBtntitle:(NSString *)title withimage:(NSString *)imagename{
    
    //选择时间的按钮
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(0, 0, 60, 30);
    //先设置按钮里面的内容居中
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //设置文字居左 －>向左移15(左减右加)
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    //设置图片居右 －>向右移20
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [rightButton setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //    rightButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:size2];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:size5];
    
    [rightButton setTitle:title forState:UIControlStateNormal];
    
    UIBarButtonItem *addnewBtn=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel follow];
    }];
    self.navigationItem.rightBarButtonItem = addnewBtn;
}

- (IBAction)legalButton:(UIButton *)sender {
    [self ViewWithTitle:@"法律法规依据" AndContent:self.viewModel.itemLegal];
}

- (IBAction)termButton:(id)sender {
    [self ViewWithTitle:@"审批范围和条件" AndContent:self.viewModel.itemTerm];
}

- (IBAction)documentButton:(id)sender {
    [self ViewWithTitle:@"审批材料" AndContent:self.viewModel.itemDocument];
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

@end
