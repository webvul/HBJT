//
//  EJGuildItemDetailViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/28.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJGuildItemDetailViewController.h"
#import "EJGuildItemDetailViewModel.h"

@interface EJGuildItemDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemSetupOfficeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemImplementOfficeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemUndertakeOfficeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemParticipateOfficeLabel;
@property (weak, nonatomic) IBOutlet UIWebView *itemLegalLabel;
@property (weak, nonatomic) IBOutlet UIWebView *itemTermLabel;
@property (weak, nonatomic) IBOutlet UIWebView *itemDocumentLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemConsultationLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemComplaintLabel;

@property (strong, nonatomic) MBProgressHUD *hub;
@property (strong, nonatomic) EJGuildItemDetailViewModel *viewModel;

@end

@implementation EJGuildItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView=[self returnTitle:@"办事指南"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_viewModel loadItemInfo];
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

- (void)bindViewModelForNotice
{
    RAC(self, itemNameLabel.text) = RACObserve(self.viewModel, itemName);
    RAC(self, itemSetupOfficeLabel.text) = RACObserve(self.viewModel, itemSetupOffice);
    RAC(self, itemImplementOfficeLabel.text) = RACObserve(self.viewModel, itemImplementOffice);
    RAC(self, itemUndertakeOfficeLabel.text) = RACObserve(self.viewModel, itemUndertakeOffice);
    RAC(self, itemParticipateOfficeLabel.text) = RACObserve(self.viewModel, itemParticipateOffice);

    [RACObserve(self.viewModel, itemLegal) subscribeNext:^(id x) {
        [self.itemLegalLabel loadHTMLString:x baseURL:nil];
    }];
    [RACObserve(self.viewModel, itemTerm) subscribeNext:^(id x) {
        [self.itemTermLabel loadHTMLString:x baseURL:nil];
    }];
    [RACObserve(self.viewModel, itemDocument) subscribeNext:^(id x) {
        [self.itemDocumentLabel loadHTMLString:x baseURL:nil];
    }];
    
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
        NSLog(@"%@",sender);
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

@end
