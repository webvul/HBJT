//
//  EJIndexViewController.m
//  hbjt
//
//  Created by 方秋鸣 on 16/1/18.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJIndexViewController.h"
#import "AppDelegate.h"


@interface EJIndexViewController ()

@property (strong, nonatomic) EJIndexViewModel *viewModel;


@property (strong, nonatomic) IBOutlet UIButton *button0;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) IBOutlet UIButton *button4;
@property (strong, nonatomic) IBOutlet UIButton *button5;
@property (strong, nonatomic) IBOutlet UIButton *button6;
@property (strong, nonatomic) IBOutlet UIButton *button7;
@property (strong, nonatomic) IBOutlet UIButton *button8;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *imageViewArray;

@property (assign, nonatomic) NSInteger numberOfSrollViewPage;
@property (assign, nonatomic) CGFloat scrollViewWidth;

@end

@implementation EJIndexViewController

CGFloat scrollViewOffsetx;


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfSrollViewPage = kEJSSetNumberOfIndexSrollViewPage;
    self.scrollViewWidth = self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(self.scrollViewWidth, 0) animated:NO];
    self.buttonArray = @[self.button0, self.button1, self.button2, self.button3, self.button4,
                        self.button5, self.button6, self.button7, self.button8];
    [self scrollViewControl];
}

- (void)layoutSubviews
{
    for (NSInteger i=0; i<self.numberOfSrollViewPage; i++) {
        [UIImageView alloc]in
    }
}

- (void)scrollViewControl
{
 /*   @weakify(self);
    [RACObserve(self.scrollView, contentOffset) subscribeNext:^(id x) {
        @strongify(self);
               }
    }];*/

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedDelegate] setLeftDrawerViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Reactive Method

- (void)bindViewModelToUpdate
{
    CGFloat scrollViewWidth = self.scrollView.frame.size.width;
    RAC(self.viewModel, scrollViewOffset) = [RACObserve(self, scrollView.contentOffset.x) map:^id(id value) {
        return @([value floatValue]/scrollViewWidth);
    }];
}

- (void)bindViewModelForNotice
{
    //Scroll View Rotate
    CGFloat scrollViewWidth = self.scrollView.frame.size.width;
    [self.viewModel.scrollViewRotateSignal subscribeNext:^(id x) {
        [self.scrollView setContentOffset:CGPointMake(scrollViewWidth*[x floatValue], 0) animated:NO];
    }];
    
    [[self.button8 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"ServicesGuild" bundle:nil] instantiateInitialViewController] animated:YES];
    }];
}

- (void)prepareOtherViewController
{
    EJNewsViewController *newsViewController = [[AppDelegate sharedDelegate] newsViewController];
    for (NSInteger i; i<self.buttonArray.count; i++) {
        [[self.buttonArray[i] rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self prepareViewController:newsViewController withSender:@(i)];
        }];
    }
}

- (IBAction)didTappedMenuButton:(UIBarButtonItem *)sender {
    //[self.sideMenuViewController presentLeftMenuViewController];
}



@end
