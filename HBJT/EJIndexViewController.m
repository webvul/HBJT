//
//  EJIndexViewController.m
//  hbjt
//
//  Created by 方秋鸣 on 16/1/18.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJIndexViewController.h"
#import "AppDelegate.h"
#import "EJIndexViewModel.h"
#import "EJS/EJS.h"


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
@property (strong, nonatomic) IBOutlet UIView *scrollContentView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewAspect;

@property (strong, nonatomic) NSArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *imageViewArray;

@property (assign, nonatomic) NSInteger numberOfSrollViewPage;
@property (assign, nonatomic) CGFloat scrollViewWidth;
@property (assign, nonatomic) CGPoint scrollViewOffsetHolder;


@end

@implementation EJIndexViewController

CGFloat scrollViewOffsetx;


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonArray = @[self.button0, self.button1, self.button2, self.button3, self.button4,
                        self.button5, self.button6, self.button7, self.button8];
    self.imageViewArray = [[NSMutableArray alloc]init];
    self.numberOfSrollViewPage = kEJSSetNumberOfIndexSrollViewPage+2;
    self.scrollViewWidth = self.scrollView.frame.size.width;
    for (NSInteger i=0; i<self.numberOfSrollViewPage; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PlaceHolder.jpg"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageViewArray addObject:imageView];
        [self.scrollContentView addSubview:imageView];
    }
    [self createLayoutConstraints];
    [self.scrollView setContentOffset:CGPointMake(self.scrollViewWidth, 0) animated:NO];
}

- (void)createLayoutConstraints
{
    NSInteger i = 0;
    //masonry的block不需要weakself
    for (UIImageView *imageView in self.imageViewArray) {
        [imageView makeConstraints:^(MASConstraintMaker *make){
            make.size.and.top.equalTo(self.scrollView);
            make.leading.equalTo(self.scrollContentView).offset(self.scrollViewWidth*i);
        }];
        imageView.backgroundColor = [UIColor colorWithHue:(CGFloat)((double)i/(double)self.imageViewArray.count) saturation:1 brightness:1 alpha:1];
        i++;
    }
    [self.scrollContentView makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(self.scrollContentView.height).multipliedBy((double)i*9/4);
    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //没用考虑横屏的情况
    self.scrollViewOffsetHolder = self.scrollView.contentOffset;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //没用考虑横屏的情况
    [self.scrollView setContentOffset:self.scrollViewOffsetHolder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel connect];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[AppDelegate sharedDelegate] setkeyboardDistance];
        [self prepareOtherViewController];
    });
    [[AppDelegate sharedDelegate] setLeftDrawerViewController];
    [[AppDelegate sharedDelegate] toggleDrawerOpenGesture:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[AppDelegate sharedDelegate] toggleDrawerOpenGesture:NO];
    [self.viewModel disconnect];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.viewModel = nil;
}

#pragma mark - Reactive Method

- (void)bindViewModelToUpdate
{
    self.viewModel.numberOfSrollViewPage = self.numberOfSrollViewPage;
    @weakify(self);
    RAC(self.viewModel, scrollViewOffset) = [RACObserve(self.scrollView, contentOffset) map:^id(id value) {
        @strongify(self);
        return @(self.scrollView.contentOffset.x/self.scrollViewWidth);
   }];
}

- (void)bindViewModelForNotice
{
    //Scroll View Rotate
    @weakify(self);
    [self.viewModel.scrollViewRotateSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*[x floatValue], 0) animated:NO];
    }];
    RAC(self.pageControl, currentPage) = self.viewModel.pageIndicatorTintSignal;
    
    [[self.button8 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"ServicesGuild" bundle:nil] instantiateInitialViewController] animated:YES];
    }];
}

- (void)prepareOtherViewController
{
    [[self.menuButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[AppDelegate sharedDelegate] openDrawer];
    }];
}

#pragma mark - Getters

- (EJIndexViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [EJIndexViewModel viewModel];
        [self bindViewModel];
    }
    return _viewModel;
}

@end
