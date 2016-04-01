//
//  EJResultDetailViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/4/1.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJResultDetailViewController.h"
#import "EJResultDetailViewModel.h"

@interface EJResultDetailViewController ()

@property (strong, nonatomic) EJResultDetailViewModel *viewModel;

@end

@implementation EJResultDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.[
    [self bindViewModel];
    [self.viewModel load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)preparedWithSender:(id)sender
{
    if ([sender isKindOfClass:[NSDictionary class]]) {
        self.viewModel.resultType = [[sender objectForKey:@"type"] integerValue];
        self.viewModel.resultID = [sender objectForKey:@"id"];
    }
}

- (void)bindViewModelForNotice
{
    self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            if ([x isEqualToString:@"事项获取成功"]) {
                self.
                [self transferNonull:@"extItemname" named:@"resultName"];
                [self transferNonull:@"createTime" named:@"resultSubmitDate"];
                [self transferNonull:@"leftDateNumber" named:@"resultEstimateTime"];
                [self transferNonull:@"extCode" named:@"resultNumber"];
                [self transferNonull:@"extUsername" named:@"resultProposer"];
                [self transferNonull:@"flowStatus" named:@"resultStep"];
                [self transferNonull:@"completeStatus" named:@"result"];
                [self transferNonull:@"acceptTime" named:@"resultAcceptDate"];

            }
        }
    }
}

- (EJResultDetailViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJResultDetailViewModel viewModel];
        [_viewModel connect];
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
