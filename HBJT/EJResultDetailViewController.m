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
@property (weak, nonatomic) IBOutlet UILabel *resultNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultSubmitDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultEstimateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultProposerLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultStepLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultAcceptDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultSourceLabel;

@property (strong, nonatomic) EJResultDetailViewModel *viewModel;

@end

@implementation EJResultDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.titleView=[self returnTitle:@"结果公示详细"];
    
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
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            if ([x isEqualToString:@"事项获取成功"]) {
                NSLog(@"%@",self.viewModel.data);
                self.resultNameLabel.text = [self.viewModel.data objectForKey:@"resultName"];
                self.resultSubmitDateLabel.text = [self.viewModel.data objectForKey:@"resultSubmitDate"];
                self.resultEstimateTimeLabel.text = ([self.viewModel.data objectForKey:@"resultEstimateTime"]? [[[self.viewModel.data objectForKey:@"resultEstimateTime"] stringValue] stringByAppendingString:@"天"]: nil);
                self.resultNumberLabel.text = [self.viewModel.data objectForKey:@"resultNumber"];

                self.resultProposerLabel.text = [self.viewModel.data objectForKey:@"resultProposer"];

                self.resultStepLabel.text = [self.viewModel.data objectForKey:@"resultStep"];
                self.resultLabel.text = [self.viewModel.data objectForKey:@"result"];
                self.resultAcceptDateLabel.text = [self.viewModel.data objectForKey:@"resultAcceptDate"];
            }
        }
    }];
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
