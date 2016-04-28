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
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;
@property (strong, nonatomic) EJSuggestionViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *suggestionTextView;
@property (strong, nonatomic) MBProgressHUD *hub;
@property (strong ,nonatomic) UILabel *label;

@end

@implementation EJSuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView=[self returnTitle:(self.isLetter?@"我的留言":@"审批建议")];
    self.scrollView.scrollEnabled = (self.view.frame.size.height < 500);
//    self.suggestLabel.text = (self.isLetter?@"留言内容":@"建议内容");
    self.label = [[UILabel alloc] init];
    self.label.text = (self.isLetter?@"请输入您的留言（必填）":@"请输入建议内容（必填）");
    self.label.enabled = YES;//lable必须设置为不可用
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.22];
    self.label.font = [UIFont systemFontOfSize:14];
    [self.suggestionTextView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.suggestionTextView.mas_top).with.offset(5.0f);
        make.left.equalTo(self.suggestionTextView.mas_left).with.offset(5.0f);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width -30, 26));
    }];
    [self bindViewModel];
}

- (void)bindViewModelToUpdate
{
    [[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel suggest];
    }];
    RAC(self.viewModel, suggestionText) = [self.suggestionTextView rac_textSignal];
    RAC(self.viewModel, nameText) = self.nameTextField.rac_textSignal;
    RAC(self.viewModel, emailText) = self.emailTextField.rac_textSignal;
    RAC(self.viewModel, phoneText) = self.phoneTextField.rac_textSignal;
    RAC(self.viewModel, qqText) = self.qqTextField.rac_textSignal;

    [[self.suggestionTextView rac_textSignal] subscribeNext:^(id x) {
        self.label.text = ([x isEqualToString:@""]? (self.isLetter?@"请输入您的留言（必填）":@"请输入建议内容（必填）"):  @"");
    }];
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
    
    [[[[[self.viewModel.networkHintSignal filter:^BOOL(id value) {
        return [value isKindOfClass:[NSString class]];
    }] filter:^BOOL(id value) {
        return [value isEqualToString:@"操作成功"];
    }] doNext:^(id x) {
        self.suggestionTextView.text = @"";
    } ] delay:1.0] subscribeNext:^(id x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
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

@end
