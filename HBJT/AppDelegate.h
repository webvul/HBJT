//
//  AppDelegate.h
//  hbjt
//
//  Created by 方秋鸣 on 16/2/24.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EJFramework.h"
#import "EJIndexViewController.h"
#import "EJMenuTableViewController.h"
#import "EJNewsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IQKeyboardManager *keyboardManager;
@property (strong, nonatomic) MMDrawerController *drawerController;
@property (strong, nonatomic) EJIndexViewController *indexViewController;
@property (strong, nonatomic) EJMenuTableViewController *menuTableViewController;
@property (strong, nonatomic) EJNewsViewController *newsViewController;
@property (strong, nonatomic) UINavigationController *rootNavigationController;
@property (strong, nonatomic) NSMutableDictionary *userinfo;

+ (instancetype)sharedDelegate;
- (void)setLeftDrawerViewController;
- (void)setkeyboardDistance;
- (void)push:(UIViewController *)viewController;
- (void)toggleDrawerOpenGesture:(BOOL)enbaled;


@end

