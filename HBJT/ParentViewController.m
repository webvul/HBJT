//
//  ParentViewController.m
//  YiJi_Pos_Apily
//
//  Created by work on 15/1/19.
//  Copyright (c) 2015年 ggwl. All rights reserved.
//

#import "ParentViewController.h"


@interface ParentViewController (){
    
}

@end


@implementation ParentViewController
#pragma mark----------nav
-(void)returnBack{
    UIButton *leftBackBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBackBtn.frame=CGRectMake(0, 0, 50, 44);
    leftBackBtn.backgroundColor=[UIColor clearColor];
    
    UIImageView *sizeTitleImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"02"]];
    sizeTitleImg.frame=CGRectMake(5,10 ,24,24);
    [leftBackBtn  addSubview:sizeTitleImg];
    
//    UILabel *numLab=[[UILabel alloc] initWithFrame:CGRectMake(15, 15, 30, 21)];
//    numLab.text=@"返回";
//    numLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0f];
//    numLab.textColor=[UIColor whiteColor];
//    numLab.backgroundColor=[UIColor clearColor];
//    [leftBackBtn  addSubview:numLab];
    
    [leftBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBackBtn];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarButtonItem];
    
//    UIBarButtonItem *backBarBtn=[[UIBarButtonItem alloc] initWithCustomView:leftBackBtn];
//    self.navigationItem.leftBarButtonItem=backBarBtn;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(UILabel *)returnTitle:(NSString *)title{
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLab.font=[UIFont systemFontOfSize:20.0f];
    titleLab.backgroundColor=[UIColor clearColor];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    titleLab.text=title;
    return titleLab;
}

-(void)setNavigationBarColor:(UINavigationController *)nav{
    nav.navigationBar.tintColor = [UIColor clearColor];
    
//    [nav.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]]];
    if ([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
//        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"title.png"] forBarMetrics:UIBarMetricsDefault];
        [nav.navigationBar setBarTintColor:naviBG];
    }
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarColor:self.navigationController];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //self.navigationController.navigationBar.clipsToBounds = YES;
    }
//    NSLog(@"start.x====%f,start.y===%f,start.width=====%f,start.height=====%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    [self returnBack];
}






@end
