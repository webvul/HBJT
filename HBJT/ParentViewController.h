//
//  ParentViewController.h
//  YiJi_Pos_Apily
//
//  Created by work on 15/1/19.
//  Copyright (c) 2015年 ggwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#define size1  11
#define size2  12
#define size5  15
#define RGB(r,g,b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define naviBG                  RGB(54,142,211)
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface ParentViewController : UIViewController
/**
 *  设置标题
 */
-(UILabel *)returnTitle:(NSString *)title;
/**
 *  返回键
 */
-(void)returnBack;
/**
 *  maskView
 */
@property(nonatomic,strong) UIView * maskView;

/**
 *  初始化 rootVC:根VC， popView:弹出的view
 */

@end
