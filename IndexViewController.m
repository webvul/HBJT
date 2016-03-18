//
//  IndexViewController.m
//  hbjt
//
//  Created by 方秋鸣 on 16/1/18.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "IndexViewController.h"


@interface IndexViewController ()

@property (weak, nonatomic) id menuViewController;
@property (strong, nonatomic) NewsViewController* newsViewController;

@property (strong, nonatomic) IBOutlet UIButton *button0;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) IBOutlet UIButton *button4;
@property (strong, nonatomic) IBOutlet UIButton *button5;
@property (strong, nonatomic) IBOutlet UIButton *button6;
@property (strong, nonatomic) IBOutlet UIButton *button7;
@property (strong, nonatomic) IBOutlet UIButton *button8;
@property (strong, nonatomic) NSArray *buttonArray;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property CGFloat scrollViewOffsetx;

@property (strong, nonatomic) RACSignal *timer;
@property NSInteger timerCount;

@property (strong, nonatomic) IndexViewModel *viewModel;

@end

@implementation IndexViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.menuViewController setValue:self forKeyPath:@"indexViewController"];
    self.newsViewController = [[UIStoryboard storyboardWithName:@"News" bundle:nil] instantiateInitialViewController];
    
    
    self.scrollViewOffsetx = self.view.frame.size.width - 40;
    [self.scrollView setContentOffset:CGPointMake(self.scrollViewOffsetx, 0) animated:NO];
    
    @weakify(self);
    self.buttonArray = [NSArray arrayWithObjects:self.button0, self.button1, self.button2, self.button3, self.button4,
                        self.button5, self.button6, self.button7, self.button8, nil];
    for (NSInteger i = 0; i<6; i++) {
        [[self.buttonArray[i] rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            self.newsViewController.tabNumber = i;
            [self.navigationController pushViewController:self.newsViewController animated:YES];
        }];
    }
    [[self.button8 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"ServicesGuild" bundle:nil] instantiateInitialViewController] animated:YES];
    }];
    [self scrollViewControl];
    [self bindViewModel];
}

- (void)scrollViewControl
{
    @weakify(self);
    [RACObserve(self.scrollView, contentOffset) subscribeNext:^(id x) {
        @strongify(self);
        if (self.scrollView.contentOffset.x > self.scrollViewOffsetx*4.99) {
            [self.scrollView setContentOffset:CGPointMake(self.scrollViewOffsetx*1.0, 0) animated:NO];
        }
        if (self.scrollView.contentOffset.x < self.scrollViewOffsetx*0.01) {
            [self.scrollView setContentOffset:CGPointMake(self.scrollViewOffsetx*4.0, 0) animated:NO];
        }
        if ((self.scrollView.contentOffset.x < self.scrollViewOffsetx)||((self.scrollView.contentOffset.x >= self.scrollViewOffsetx*4) && (self.scrollView.contentOffset.x < self.scrollViewOffsetx*5))) {
            self.pageControl.currentPage = 3;
        }
        if ((self.scrollView.contentOffset.x >= self.scrollViewOffsetx*5)||((self.scrollView.contentOffset.x >= self.scrollViewOffsetx*1) && (self.scrollView.contentOffset.x < self.scrollViewOffsetx*2))) {
            self.pageControl.currentPage = 0;
        }
        if ((self.scrollView.contentOffset.x >= self.scrollViewOffsetx*2) && (self.scrollView.contentOffset.x < self.scrollViewOffsetx*3)) {
            self.pageControl.currentPage = 1;
        }
        if ((self.scrollView.contentOffset.x >= self.scrollViewOffsetx*3) && (self.scrollView.contentOffset.x < self.scrollViewOffsetx*4)) {
            self.pageControl.currentPage = 2;
        }
    }];

}

- (void)bindViewModel
{
    self.viewModel = [[IndexViewModel alloc]init];
    }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isNeedShowMenu) {
        //[self.sideMenuViewController presentLeftMenuViewController];
        self.isNeedShowMenu = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTappedMenuButton:(UIBarButtonItem *)sender {
    //[self.sideMenuViewController presentLeftMenuViewController];
}

- (void)setNeedShowMenu
{
    self.isNeedShowMenu = YES;
}


@end
