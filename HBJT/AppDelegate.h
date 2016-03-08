//
//  AppDelegate.h
//  hbjt
//
//  Created by 方秋鸣 on 16/2/24.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EJFramework.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *usernameString;
@property (strong, nonatomic) NSString *userIDString;
@property (strong, nonatomic) NSString *userNumberString;
@property (strong, nonatomic) NSString *userPhoneString;
@property (strong, nonatomic) NSString *userAddressString;
@property (assign, nonatomic) BOOL currentUser;
@property (assign, nonatomic) BOOL needDrawerReopen;

+ (instancetype)sharedDelegate;

- (void)setkeyboardDistance;

- (void)setLeftDrawerViewController;
- (void)toggleDrawerOpenGesture:(BOOL)enbaled;
- (void)openDrawer;
- (void)closeDrawerNeedReopen:(BOOL)needReopen;
- (void)setNeedDrawerReopen:(BOOL)needDrawerReopen;

- (void)push:(UIViewController *)viewController;

- (void)setCurrentUser:(BOOL)isCurrentUser;
- (void)setUsername:(NSString *)usernameString
             userID:(NSString *)userIDString
         userNumber:(NSString *)userNumberString
          userPhone:(NSString *)userPhoneString
        userAddress:(NSString *)userAddressString;



@end

