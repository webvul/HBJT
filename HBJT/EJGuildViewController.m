//
//  EJGuildViewController.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/22.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJGuildViewController.h"
#import "EJGuildViewModel.h"
#import "EJGuildPrimaryItemTableViewController.h"

@interface EJGuildViewController ()
@property (weak, nonatomic) IBOutlet UIView *guildView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *locateButton;
@property (weak, nonatomic) IBOutlet UIButton *switchCityButton;
@property (weak, nonatomic) IBOutlet UIScrollView *areaScrollView;
@property (weak, nonatomic) IBOutlet UIView *areaScrollContentView;

@property (strong, nonatomic) NSMutableArray *districtButtonArray;
@property (strong, nonatomic) NSMutableArray *sectionButtonArray;
@property (strong, nonatomic) MBProgressHUD *hub;
@property (strong, nonatomic) EJGuildViewModel *viewModel;
@end

@implementation EJGuildViewController

- (void)viewDidLoad
{
    self.viewModel = [EJGuildViewModel viewModel];
    [self bindViewModel];
    [self.viewModel connect];
    [self.viewModel loadAreaList];
}

- (void)loadAreaScrollView
{
    for (UIButton *button in self.districtButtonArray) {
        [button removeFromSuperview];
    }
    self.districtButtonArray = [[NSMutableArray alloc]init];
    NSInteger i = 0;
    for (NSDictionary *areaInfo in self.viewModel.districtArray) {
        UIButton *districtButton = [[[NSBundle mainBundle] loadNibNamed:@"GuildDistrictButton" owner:self options:nil] firstObject];
        [self.areaScrollContentView addSubview:districtButton];
        NSString *title = [areaInfo objectForKey:@"areaName"];
        [districtButton setTitle:(title.length>4?[title substringToIndex:4]:title) forState:UIControlStateNormal];
        [districtButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.areaScrollContentView);
            if (self.districtButtonArray.count == 0) {
                make.leading.equalTo(self.areaScrollContentView).offset(10);
            }
            else
            {
                make.leading.equalTo([(UIButton *)self.districtButtonArray.lastObject trailing]).offset(22);
            }
            make.size.mas_equalTo(CGSizeMake(28, 85));
        }];
        [self.districtButtonArray addObject:districtButton];
        [[districtButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            self.viewModel.currentDistrictIndex = i;
        }];
        i ++;
    }
    [self.districtButtonArray.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.areaScrollContentView).offset(-10);
    }];
}

- (void)loadSectionButtons
{
    for (UIButton *button in self.sectionButtonArray) {
        [button removeFromSuperview];
    }
    NSInteger i = 0;
    self.sectionButtonArray = [[NSMutableArray alloc] init];
    if (self.viewModel.sectionArray.count > 0) {
        for (NSDictionary *sectionInfo in self.viewModel.sectionArray) {
            UIButton *sectionButton = [[[NSBundle mainBundle] loadNibNamed:@"GuildSectionButton" owner:self options:nil] firstObject];
            [self.guildView addSubview:sectionButton];
            [sectionButton setTitle:[sectionInfo objectForKey:@"itemname"] forState:UIControlStateNormal];
            [sectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.guildView).offset(25);
                make.trailing.equalTo(self.guildView).offset(-25);
                make.width.equalTo(sectionButton.height).multipliedBy(60/7);
                if (self.sectionButtonArray.count == 0) {
                    make.top.equalTo(self.areaScrollView.bottom).offset(27);
                }
                else
                {
                    make.top.equalTo([(UIButton *)self.sectionButtonArray.lastObject bottom]).offset(20);
                }
            }];
            [[sectionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                EJGuildPrimaryItemTableViewController *primaryItemViewController = [[UIStoryboard storyboardWithName:@"Guild" bundle:nil] instantiateViewControllerWithIdentifier:@"PrimaryItem"];
                //NSLog(@"%@",[self.viewModel.sectionArray[i] objectForKey:@"id"]);
                [self prepareViewController:primaryItemViewController withSender:[self.viewModel.sectionArray[i] objectForKey:@"id"]];
                [self.navigationController pushViewController:primaryItemViewController animated:YES];
            }];
            [self.sectionButtonArray addObject:sectionButton];
            i++;
        }
        [self.guildView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo([(UIButton *)self.sectionButtonArray.lastObject bottom]).offset(27);
        }];
    }
}
    

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIScrollView *scrollView = (UIScrollView *)self.guildView.superview;
    if (self.sectionButtonArray.count > 0) {
        scrollView.scrollEnabled = (((UIButton *)self.sectionButtonArray.lastObject).frame.origin.y > self.guildView.frame.size.height - 34-27);
        //NSLog(@"%f,%f", ((UIButton *)self.sectionButtonArray.lastObject).frame.origin.y,self.guildView.frame.size.height - 34-27);
    }
    else
    {
        scrollView.scrollEnabled = NO;
    }
    if (!scrollView.scrollEnabled)
    {
        [scrollView setContentOffset:(CGPoint){0,0} animated:YES];
    }
}

- (void)bindViewModelToUpdate
{
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            if ([x isEqualToString:@"区域信息读取成功"]) {
                self.cityLabel.text = [self.viewModel.cityArray[self.viewModel.currentCityIndex] objectForKey:@"areaName"];
                [self loadAreaScrollView];
            }
            else if ([x isEqualToString:@"正在获取区域信息"])
            {
                
            }
            else if ([x isEqualToString:@"部门信息读取成功"])
            {
                [self loadSectionButtons];
            }
            else
            {
                if (self.viewModel.cityArray == nil) {
                    [self.viewModel loadAreaList];
                }
            }
        }
    }];
    @weakify(self);
    [[self.switchCityButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.viewModel.cityArray != nil) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请选择所在区域"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            NSInteger i = 0;
            for (NSDictionary *cityInfo in self.viewModel.cityArray) {
                UIAlertAction* cityAction = [UIAlertAction actionWithTitle:[cityInfo objectForKey:@"areaName"] style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          @strongify(self);
                                                                          self.viewModel.currentCityIndex = i;
                                                                          self.cityLabel.text = [self.viewModel.cityArray[self.viewModel.currentCityIndex] objectForKey:@"areaName"];
                                                                          [self loadAreaScrollView];
                                                                      }];
                [alert addAction:cityAction];
                i ++;
            }
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
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

- (void)bindViewModelForNotice
{
    
}
@end
