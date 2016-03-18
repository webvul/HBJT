//
//  UIViewController+FTBinding.h
//  FTools
//
//  Created by 方秋鸣 on 16/3/2.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/foundation.h>
#import <objc/runtime.h>
#import "FTViewModel.h"


@interface UIViewController (FTBinding)
/**
 *  动态为View Controller添加View Model属性。
 */
@property (strong, nonatomic, nullable)FTViewModel *viewModel;
/**
 *  约定View Controller将以何种方式更新View Model信息。
 */
- (void)bindViewModelToUpdate;
/**
 *  约定View Model改变时View Controller将以何种方式更新界面。
 */
- (void)bindViewModelForNotice;
/**
 *  约定View Controller如何跳转到其他界面。
 */
- (void)prepareOtherViewController;
/**
 *  当从另一个View Controller跳转进入前，如用必要可调用此方法向此View Controller的View Model发送初始配置信息。
 *
 *  @param sender 包含跳转入View Controller初始配置信息的对象。
 */
- (void)preparedWithSender:(__nullable id)sender;
/**
 *  当跳转进入另一个View Controller前，使用此方法向该View Controller发送初始配置信息,并执行跳转。
 *
 *  @param viewContorller 将要跳入的View Controller。
 *  @param sender 包含跳转入View Controller初始配置信息的对象。
 */
- (void)prepareViewController:(nonnull UIViewController *)viewContorller withSender:(__nullable id)sender;

@end
