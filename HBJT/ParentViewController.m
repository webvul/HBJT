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


-(void)fristRightBtntitle:(NSString *)title withimage:(NSString *)imagename{
    
    UIButton *fristRightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fristRightBtn.frame=CGRectMake(0, 0, 30, 44);
    fristRightBtn.backgroundColor=[UIColor clearColor];
    //    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(25, 4, 20, 20)];
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 4, 20, 20)];
    
    imageview.image=[UIImage imageNamed:imagename];
    [fristRightBtn addSubview:imageview];
    UILabel *numLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 20,50 , 20)];
    numLab.text=title;
    numLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:size2];
    numLab.textColor=[UIColor whiteColor];
    numLab.backgroundColor=[UIColor clearColor];
    [fristRightBtn  addSubview:numLab];
    [fristRightBtn addTarget:self action:@selector(fristRightBtnclick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addnewBtn=[[UIBarButtonItem alloc] initWithCustomView:fristRightBtn];
    self.navigationItem.rightBarButtonItem = addnewBtn;
}


-(void)secondRightBtntitle:(NSString *)title withimage:(NSString *)imagename{
    
    //选择时间的按钮
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.backgroundColor = [UIColor blueColor];
    rightButton.frame=CGRectMake(0, 0, 60, 30);
    //先设置按钮里面的内容居中
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //设置文字居左 －>向左移15(左减右加)
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    //设置图片居右 －>向右移20
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
    [rightButton setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //    rightButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:size2];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:size2];
    
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(fristRightBtnclick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addnewBtn=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = addnewBtn;
}


-(void)rightSureButton{
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(sureButton)];
    rightButton.tintColor = [UIColor whiteColor];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:size5], NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)sureButton{
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
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
-(void)fristRightBtnclick{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarColor:self.navigationController];
    _isRight=NO;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //self.navigationController.navigationBar.clipsToBounds = YES;
    }
//    NSLog(@"start.x====%f,start.y===%f,start.width=====%f,start.height=====%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
}
- (void)createUI
{
    //rootVC上的maskView
    _maskView = ({
        UIView * maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        maskView.alpha = 0.2;
        maskView;
    });
    UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taprecognizer)];
    [_maskView addGestureRecognizer:recognizer];
}
-(void)taprecognizer{
    if (_isRight) {
        [self closeRightView];
    }else
    [self close];
}
- (void)close
{
    CGRect frame = _popView.frame;
    frame.origin.y += _popView.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //maskView隐藏
        [_maskView setAlpha:0.f];
        //popView下降
        _popView.frame = frame;
        
        //同时进行 感觉更丝滑
        [_rootview.layer setTransform:[self firstTransform]];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //变为初始值
            [_rootview.layer setTransform:CATransform3DIdentity];
            
        } completion:^(BOOL finished) {
            
            //移除
            [_popView removeFromSuperview];
            [_maskView removeFromSuperview];
        }];
        
    }];
    
    
    
}

- (void)show
{
    [[UIApplication sharedApplication].windows[0] addSubview:_popView];
    
    CGRect frame = _popView.frame;
    frame.origin.y = Screen_Height- _popView.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_rootview.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_rootview addSubview:_maskView];
            [_rootview.layer setTransform:[self secondTransform]];
            //显示maskView
            [_maskView setAlpha:0.5f];
            //popView上升
            _popView.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
}

- (CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    //带点缩小的效果
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    //绕x轴旋转
    t1 = CATransform3DRotate(t1, 15.0 * M_PI/180.0, 1, 0, 0);
    return t1;
    
}

- (CATransform3D)secondTransform{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    //向上移
    t2 = CATransform3DTranslate(t2, 0, self.view.frame.size.height * (-0.08), 0);
    //第二次缩小
    t2 = CATransform3DScale(t2, 0.9, 0.9, 1);
    return t2;
}
-(void)showRightView{
    [[UIApplication sharedApplication].windows[0] addSubview:_popView];
    CGRect frame = _popView.frame;
    frame.origin.x = Screen_Width- _popView.frame.size.width;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
        //[_rootview.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            [_rootview addSubview:_maskView];
            //[_rootview.layer setTransform:[self secondTransform]];
            //显示maskView
            [_maskView setAlpha:0.5f];
            //popView上升
            _popView.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}
-(void)closeRightView{
    CGRect frame = _popView.frame;
    frame.origin.x += _popView.frame.size.width;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
        //maskView隐藏
        [_maskView setAlpha:0.f];
        //popView下降
        _popView.frame = frame;
        
        //同时进行 感觉更丝滑
        //[_rootview.layer setTransform:[self firstTransform]];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            //变为初始值
           // [_rootview.layer setTransform:CATransform3DIdentity];
            
        } completion:^(BOOL finished) {
            
            //移除
            [_popView removeFromSuperview];
            [_maskView removeFromSuperview];
        }];
        
    }];
}

@end
