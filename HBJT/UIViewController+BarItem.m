//
//  UIViewController+BarItem.m
//  KnightIsland
//
//  Created by shscce on 15/6/8.
//  Copyright (c) 2015年 shscce. All rights reserved.
//

#import "UIViewController+BarItem.h"
//获取颜色的RGB
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
@implementation UIViewController (BarItem)


- (void)setNavgationTitle:(NSString *)title textColor:(UIColor *)textColor font:(UIFont *)font {
    
    //导航条的背景颜色
    self.navigationController.navigationBar.barTintColor = RGB(37, 126, 215);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = font ? font : [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColor ? textColor : [UIColor whiteColor];
    label.text = title;
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (UIBarButtonItem *)itemWithTitle:(NSString *)title action:(SEL)action{
    
    return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
}

- (UIBarButtonItem *)itemWithImage:(UIImage *)image action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

- (void)setLeftItemWithTitle:(NSString *)title action:(SEL)action{
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [self itemWithTitle:title action:action];
}

- (void)setLeftItemWithImageName:(NSString *)imageName action:(SEL)action{
    
    self.navigationItem.leftBarButtonItem = nil;
    UIImage *image = [UIImage imageNamed:imageName];
    self.navigationItem.leftBarButtonItem = [self itemWithImage:image action:action];
}

- (void)setRightItemWithTitle:(NSString *)title action:(SEL)action{
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [self itemWithTitle:title action:action];
    ///设置右边btn的颜色
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
}

- (void)setRightItemWithImageName:(NSString *)imageName action:(SEL)action{
   
    self.navigationItem.rightBarButtonItem = nil;
    UIImage *image = [UIImage imageNamed:imageName];
    self.navigationItem.rightBarButtonItem = [self itemWithImage:image action:action];
}

- (void)setBackItemWithImageName:(NSString *)imageName action:(SEL)action{
    self.navigationItem.backBarButtonItem = nil;
    UIImage *image = [UIImage imageNamed:imageName];
    self.navigationItem.leftBarButtonItem = [self itemWithImage:image action:action];
}

- (void)viewBack{
    [self.navigationController popViewControllerAnimated:YES];
//    [SVProgressHUD dismiss];
}
@end
