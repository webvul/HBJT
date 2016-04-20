//
//  EJSuggestionViewController.m
//  HBJT
//
//  Created by Davina on 16/3/14.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJSuggestionViewController.h"
#import "EJSuggestionViewModel.h"

@interface EJSuggestionViewController ()
@property (assign, nonatomic) BOOL isLetter;
@property (weak, nonatomic) IBOutlet UILabel *suggestLabel;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;
@property (strong, nonatomic) IBOutlet UITextField *suggestionTextField;
@property (strong, nonatomic) EJSuggestionViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *suggestionTextView;
@property (strong, nonatomic) MBProgressHUD *hub;

@end

@implementation EJSuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView=[self returnTitle:(self.isLetter?@"我的留言":@"审批建议")];
    self.scrollView.scrollEnabled = (self.view.frame.size.height < 500);

    self.suggestLabel.text = (self.isLetter?@"留言内容":@"建议内容");
    self.suggestionTextField.placeholder = (self.isLetter?@"请输入您的留言":@"请输入建议内容");
    [self bindViewModel];
}

- (void)bindViewModelToUpdate
{
    [[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel suggest];
    }];
    RAC(self.viewModel, suggestionText) = [self.suggestionTextView rac_textSignal];
}

- (void)bindViewModelForNotice
{
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            [self.hub setLabelText:x];
        } else if ([x boolValue]) {
            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.hub setYOffset:0];
        } else {
            [self.hub hide:YES afterDelay:1];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)preparedWithSender:(id)sender
{
    if (sender) {
        self.isLetter = YES;
    }
}

- (EJSuggestionViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJSuggestionViewModel viewModel];
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
