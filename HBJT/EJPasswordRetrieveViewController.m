//
//  EJPasswordRetrieveViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/29.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJPasswordRetrieveViewController.h"

@interface EJPasswordRetrieveViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *smsSenderButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *passwordRetrieveButton;

@end

@implementation EJPasswordRetrieveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
