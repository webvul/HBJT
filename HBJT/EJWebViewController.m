//
//  EJWebViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/31.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"
#import "EJWebViewController.h"

@interface EJWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSURLRequest *webRequest;
@property (assign, nonatomic) CGFloat webViewOffset;

@end

@implementation EJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //http://wx.hbjt.gov.cn/info/iList.jsp?cat_id=11272
    NSLog(@"%@",self.url);
    [self returnBack];
    self.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    NSLog(@"%@",self.webRequest);
    [self.webView loadRequest:self.webRequest];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.webViewOffset+64);
        NSLog(@"%@",@(self.webViewOffset+64));
    }];
    self.webView.scrollView.bounces = NO;
    self.navigationItem.titleView=[self returnTitle: self.title];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)preparedWithSender:(id)sender
{
    if ([sender isKindOfClass:[NSDictionary class]]) {
        self.url = [sender objectForKey:@"url"];
        self.title = [sender objectForKey:@"title"];
        self.webViewOffset = [[sender objectForKey:@"offset"] floatValue];
    }
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
