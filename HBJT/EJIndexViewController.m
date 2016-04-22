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
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) UIButton *imageButton0;
@property (strong, nonatomic) UIButton *imageButton1;
@property (strong, nonatomic) UIButton *imageButton2;
@property (strong, nonatomic) UIButton *imageButton3;
@property (strong, nonatomic) NSArray *imageButtonArray;



@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *scrollContentView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewAspect;

@property (strong, nonatomic) NSArray *buttonArray;
@property (strong, nonatomic) NSMutableArray  <UIImageView *> *imageViewArray;

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
    self.scrollViewWidth = self.view.frame.size.width -40;
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
        //imageView.contentMode = UIViewContentModeScaleAspectFill;
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
    [self.navigationController setNavigationBarHidden:YES];
    [self.viewModel connect];
    [self.viewModel loadPictures];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[AppDelegate sharedDelegate] setkeyboardDistance];
        [self prepareOtherViewController];
    });
    [[AppDelegate sharedDelegate] setLeftDrawerViewController];
    [[AppDelegate sharedDelegate] toggleDrawerOpenGesture:YES];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[AppDelegate sharedDelegate] toggleDrawerOpenGesture:NO];
    [self.viewModel disconnect];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.viewModel.pageIndicatorTintSignal subscribeNext:^(id x) {
        if (self.viewModel.picturesCaptionList.count == 4) {
            self.captionLabel.text = [NSString stringWithFormat:@" %@",self.viewModel.picturesCaptionList[[x integerValue]]];
        }
    }];
    [self.viewModel.networkHintSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            if ([x isEqualToString:@"读取成功"]) {
                self.captionLabel.hidden = NO;
                self.label.hidden = NO;
                [self.imageViewArray[0] sd_setImageWithURL:self.viewModel.picturesURLList[3] placeholderImage:[UIImage imageNamed:@"PlaceHolder.jpg"]];
                [self.imageViewArray[1] sd_setImageWithURL:self.viewModel.picturesURLList[0] placeholderImage:[UIImage imageNamed:@"PlaceHolder.jpg"]];
                [self.imageViewArray[2] sd_setImageWithURL:self.viewModel.picturesURLList[1] placeholderImage:[UIImage imageNamed:@"PlaceHolder.jpg"]];
                [self.imageViewArray[3] sd_setImageWithURL:self.viewModel.picturesURLList[2] placeholderImage:[UIImage imageNamed:@"PlaceHolder.jpg"]];
                [self.imageViewArray[4] sd_setImageWithURL:self.viewModel.picturesURLList[3] placeholderImage:[UIImage imageNamed:@"PlaceHolder.jpg"]];
                [self.imageViewArray[5] sd_setImageWithURL:self.viewModel.picturesURLList[0] placeholderImage:[UIImage imageNamed:@"PlaceHolder.jpg"]];

                self.imageButton0 = [[UIButton alloc] initWithFrame:self.imageViewArray[1].frame];
                self.imageButton1 = [[UIButton alloc] initWithFrame:self.imageViewArray[2].frame];
                self.imageButton2 = [[UIButton alloc] initWithFrame:self.imageViewArray[3].frame];
                self.imageButton3 = [[UIButton alloc] initWithFrame:self.imageViewArray[4].frame];
                self.imageButtonArray = @[self.imageButton0, self.imageButton1, self.imageButton2, self.imageButton3];
                NSInteger i = 0;
                for (UIButton *imageButton in self.imageButtonArray) {
                    [self.scrollContentView addSubview:imageButton];
                    [[imageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                        NSString *newsTitle = [self.viewModel.data[i] objectForKey:@"articleTitle"];
                        NSString *newsID = [[self.viewModel.data[i] objectForKey:@"articleID"] stringValue];
                        NSString *newsDate = [self.viewModel.data[i] objectForKey:@"articleTime"];
                        NSString *newsRead = [[self.viewModel.data[i] objectForKey:@"articleReadNumber"] stringValue];
                        NSString *newsLaud = [[self.viewModel.data[i] objectForKey:@"articleLaudNumber"] stringValue];
                        
                        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"News" bundle:nil] instantiateViewControllerWithIdentifier:@"Detail"];
                        [self prepareViewController:viewController withSender:@{@"newsTitle":newsTitle,@"newsID":newsID,@"newsDate":newsDate,@"newsRead":newsRead,@"newsLaud":newsLaud}];
                        [self.navigationController pushViewController:viewController animated:YES];

                    }];
                    i ++;
                }
            }
            else
            {
                [self.viewModel loadPictures];
            }
        }
    }];
}

- (void)prepareOtherViewController
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    @weakify(appDelegate);
    [[self.button8 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Guild" bundle:nil] instantiateInitialViewController] animated:YES];
        [appDelegate setNeedDrawerReopen:NO];

    }];
    NSInteger i = 0;
    for (UIButton *newsButton in self.buttonArray) {
        if (i == 6) {
            break;
        }
        [[newsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            UIViewController *newsViewController = [[UIStoryboard storyboardWithName:@"News" bundle:nil] instantiateInitialViewController];
            [self prepareViewController:newsViewController withSender:@(i)];
            [self.navigationController pushViewController:newsViewController animated:YES];
            [appDelegate setNeedDrawerReopen:NO];
        }];
        i++;
    }
    [[self.menuButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(appDelegate);
        [appDelegate openDrawer];
    }];
    [[self.button7 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(appDelegate);
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Index" bundle:nil]instantiateViewControllerWithIdentifier:@"Web"];
        NSString *url = [[EJSNetwork urlList] objectForKey:kEJSNetworkAPINameTraffic];
        [self prepareViewController:viewController withSender:@{@"title":@"动态路况",@"url":url,@"offset":@(-50-64)}];
        [appDelegate setNeedDrawerReopen:NO];
        [appDelegate push:viewController];
    }];
    [[self.button6 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(appDelegate);
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Index" bundle:nil]instantiateViewControllerWithIdentifier:@"Web"];
        NSString *url = [[EJSNetwork urlList] objectForKey:kEJSNetworkAPINameFee];
        [self prepareViewController:viewController withSender:@{@"title":@"规费查询",@"url":url,@"offset":@(-64)}];
        [appDelegate setNeedDrawerReopen:NO];
        [appDelegate push:viewController];
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
