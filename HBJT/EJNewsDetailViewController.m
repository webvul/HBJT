//
//  EJNewsDetailViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/28.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJNewsDetailViewController.h"
#import "EJNewsDetailViewModel.h"

@interface EJNewsDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;
@property (weak, nonatomic) IBOutlet UIButton *laudButton;
@property (weak, nonatomic) IBOutlet UILabel *laudLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) EJNewsDetailViewModel *viewModel;
@property (strong, nonatomic) MBProgressHUD *hub;

@end

@implementation EJNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self returnBack];
    self.navigationItem.titleView=[self returnTitle:@"资讯详情"];
    // Do any additional setup after loading the view.
    [[self.laudButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.hub hide:YES afterDelay:1.0];
        self.laudLabel.text = [@([self.laudLabel.text integerValue]+1) stringValue];
        self.laudButton.enabled = NO;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel loadArticleDetail];
    self.titleLabel.text = self.viewModel.articleTitle;
    self.dateLabel.text = self.viewModel.articleDate;
    self.readLabel.text = self.viewModel.articleRead;
    self.laudLabel.text = self.viewModel.articleLaud;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)preparedWithSender:(id)sender
{
    if ([sender isKindOfClass:[NSDictionary class]]) {
        self.viewModel.articleID = [sender objectForKey:@"newsID"];
        self.viewModel.articleTitle = [sender objectForKey:@"newsTitle"];
        self.viewModel.articleDate = [sender objectForKey:@"newsDate"];
        self.viewModel.articleRead = [sender objectForKey:@"newsRead"];
        self.viewModel.articleLaud = [sender objectForKey:@"newsLaud"];
    }
}

- (void)bindViewModelToUpdate
{

}

- (void)bindViewModelForNotice
{
    //RAC(self, titleLabel.text) = RACObserve(self.viewModel, articleTitle);
    [self.webView loadHTMLString:self.viewModel.htmlString baseURL:nil];
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            if ([x isEqualToString:@"读取成功"]) {
                [self.webView loadHTMLString:self.viewModel.htmlString baseURL:nil];
            }
        }
    }];
}

- (EJNewsDetailViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJNewsDetailViewModel viewModel];
        [_viewModel connect];
        [self bindViewModel];
    }
    return _viewModel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
