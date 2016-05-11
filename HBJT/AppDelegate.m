//
//  AppDelegate.m
//  hbjt
//
//  Created by 方秋鸣 on 16/2/24.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "AppDelegate.h"
#import "EJIndexViewController.h"
#import "EJMenuTableViewController.h"
#import "EJNewsViewController.h"
#import "RootNavgationController.h"
#import "XGSetting.h"
#import "FFProgressDetailVC.h"
#import "EJS.h"
#define _IPHONE80_ 80000

@interface AppDelegate ()

@property (strong, nonatomic) IQKeyboardManager *keyboardManager;
@property (strong, nonatomic) MMDrawerController *drawerController;
@property (strong, nonatomic) EJIndexViewController *indexViewController;
@property (strong, nonatomic) EJMenuTableViewController *menuTableViewController;
@property (strong, nonatomic) EJNewsViewController *newsViewController;
@property (strong, nonatomic) RootNavgationController *rootNavigationController;

@property (strong, nonatomic) NSString *pushType;
@property (strong, nonatomic) NSString *pushMsg;
@property (strong, nonatomic) NSString *pushTitle;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"App Launching");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.drawerController];
    [self.window makeKeyAndVisible];
    NSLog(@"App Launched");
    [self registerNofiticationWithOptions:launchOptions];
#if DEBUG
    [self fakeLogin];
    [self fakePush];
#endif
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"getPushed"])
    {
        [self acceptRemoteNotification];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self fakePush];
}

#pragma mark - Public Methods

+ (instancetype)sharedDelegate
{
    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];
    NSString *classCaller    = [array objectAtIndex:3];
    NSString *functionCaller = [array objectAtIndex:4];
    NSLog(@"%@ %@ is Calling Appdelegate",classCaller,functionCaller);
    return [[UIApplication sharedApplication] delegate];
}

- (NSString *)userUsernameString
{
    NSLog(@"%@,%@,%@,%@,%@,%@",_userUsernameString, _userIDString, _userNameString, _userNumberString, _userPhoneString, _userAddressString);
    return _userUsernameString;
}

- (void)setUsername:(NSString *)userUsernameString name:(NSString *)userNameString id:(NSString *)userIDString number:(NSString *)userNumberString phone:(NSString *)userPhoneString address:(NSString *)userAddressString
{
    self.userUsernameString = userUsernameString;
    self.userNameString = userNameString;
    self.userIDString = userIDString;
    self.userNumberString = userNumberString;
    self.userPhoneString = userPhoneString;
    self.userAddressString = userAddressString;
    self.currentUser = YES;
}

- (void)modifyName:(NSString *)userNameString number:(NSString *)userNumberString phone:(NSString *)userPhoneString address:(NSString *)userAddressString
{
    if (self.currentUser) {
        self.userNameString = userNameString;
        self.userNumberString = userNumberString;
        self.userPhoneString = userPhoneString;
        self.userAddressString = userAddressString;
    }
}


- (void)setIsCurrentUser:(BOOL)currentUser
{
    _currentUser = currentUser;
    (_currentUser?:[self setUsername:nil name:nil id:nil number:nil phone:nil address:nil]);
}

- (void)openDrawer
{
    [self setNeedDrawerReopen:NO];
    [self.drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)closeDrawerNeedReopen:(BOOL)needReopen
{
    [self setNeedDrawerReopen:needReopen];
    [self.drawerController closeDrawerAnimated:YES completion:nil];
}

- (void)setLeftDrawerViewController
{
    if (self.drawerController.leftDrawerViewController == nil) {
        [self.drawerController setLeftDrawerViewController:self.menuTableViewController];
    }
    if (self.needDrawerReopen == YES) {
        [[self drawerController] openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

- (void)setkeyboardDistance
{
    [self.keyboardManager setKeyboardDistanceFromTextField:120];
}

- (void)push:(nonnull UIViewController *)viewController
{
    [self toggleDrawerOpenGesture:NO];
    [self.rootNavigationController pushViewController:viewController animated:YES];
    [self.rootNavigationController setNavigationBarHidden:NO];
}

- (void)toggleDrawerOpenGesture:(BOOL)enbaled
{
    if (enbaled) {
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
    } else
    {
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }
}


#pragma mark - Getters

- (IQKeyboardManager *)keyboardManager
{
    if (_keyboardManager == nil) {
        _keyboardManager = [IQKeyboardManager sharedManager];
    }
    return _keyboardManager;
}

- (UINavigationController *)rootNavigationController
{
    if (_rootNavigationController == nil) {
        _rootNavigationController = [[UIStoryboard storyboardWithName:@"Index" bundle:nil] instantiateViewControllerWithIdentifier:@"Root"];
        _rootNavigationController.navigationBar.tintColor = naviBG;
    }
    return _rootNavigationController;
}

- (MMDrawerController *)drawerController
{
    if (_drawerController == nil) {
        _drawerController = [[MMDrawerController alloc] initWithCenterViewController:self.rootNavigationController leftDrawerViewController:nil];
        [_drawerController setShowsShadow:NO];
        [_drawerController setMaximumLeftDrawerWidth:self.window.frame.size.width*0.75];
        [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
        [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        [_drawerController setShouldStretchDrawer:NO];
        [_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState swingingDoorVisualStateBlock]];
        NSLog(@"DrawerController Initialized");
    }
    return _drawerController;
}

- (EJIndexViewController *)indexViewController
{
    if (_indexViewController == nil) {
        _indexViewController = [[UIStoryboard storyboardWithName:@"Index" bundle:nil] instantiateInitialViewController];
        NSLog(@"IndexViewController Initialized");
    }
    return _indexViewController;
}

- (EJMenuTableViewController *)menuTableViewController
{
    if (_menuTableViewController == nil) {
        _menuTableViewController = [[UIStoryboard storyboardWithName:@"Menu" bundle:nil] instantiateInitialViewController];
        NSLog(@"MenuTableViewController Initialized");
    }
    return _menuTableViewController;
}

- (EJNewsViewController *)newsViewController
{
    if (_newsViewController == nil) {
        _newsViewController = [[UIStoryboard storyboardWithName:@"News" bundle:nil] instantiateInitialViewController];
        NSLog(@"NewsViewController Initialized");
        
    }
    return _newsViewController;
}

#pragma mark - 腾讯信鸽

- (void) registerNofiticationWithOptions:(NSDictionary *)launchOptions {
    [XGPush startApp: (unsigned int)[EJSNetwork pushID] appKey:[EJSNetwork pushKey]];
    
    // 设置账户
    [XGPush setAccount:[NSString stringWithFormat:@"anonymous%@",@"123"]];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    
    if ([XGPush isUnRegisterStatus]) {
        [XGPush unRegisterDevice];
    }
    
    [XGPush initForReregister:successCallback];
    @weakify(self);
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        @strongify(self);
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        self.pushMsg = ([[userInfo objectForKey:@"msg"] isKindOfClass:[NSString class]]? [userInfo objectForKey:@"msg"]: self.pushMsg );
        self.pushType = ([[userInfo objectForKey:@"pushtype"] isKindOfClass:[NSString class]]? [userInfo objectForKey:@"pushtype"]: self.pushType );
        self.pushTitle = ([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isKindOfClass:[NSString class]]? [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]: self.pushTitle);
        if (self.pushType != nil && self.pushMsg != nil) {
            [self acceptRemoteNotification];
        }
        NSLog(@"XGPush handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"XGPush handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //清除所有通知(包含本地通知)
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    if (YES){ //(self.shouldAcceptRemoteNotificationWhenApplicationRunningForeground || ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)) {
        self.pushMsg = ([[userInfo objectForKey:@"msg"] isKindOfClass:[NSString class]]? [userInfo objectForKey:@"msg"]: self.pushMsg );
        
        self.pushType = ([[userInfo objectForKey:@"pushtype"] isKindOfClass:[NSString class]]? [userInfo objectForKey:@"pushtype"]: self.pushType );
        self.pushTitle = ([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isKindOfClass:[NSString class]]? [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]: self.pushTitle);
        if (self.pushType != nil && self.pushMsg != nil) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"getPushed"];
        }
        //推送反馈(app运行时)
        [XGPush handleReceiveNotification:userInfo];
    }
}

//-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
//    //notification是发送推送时传入的字典信息
//    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
//
//    //删除推送列表中的这一条
//    [XGPush delLocalNotification:notification];
//    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
//
//    //清空推送列表
//    //[XGPush clearLocalNotifications];
//}

#endif
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"XGPush register successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"XGPush register errorBlock");
    };
    // 设置账号
    //[XGPush setAccount:[NSString stringWithFormat:@"anonymous%@",@"123"]];
    
     NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    //打印获取的deviceToken的字符串
    NSLog(@"XGPush deviceTokenStr is %@",deviceTokenStr);
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"XGPush %@",str);
    
}

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (void)clearPush
{
    self.pushType = nil;
    self.pushMsg = nil;
    self.pushTitle = nil;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"getPushed"];
}

- (void)acceptRemoteNotification
{
    UIViewController *topViewController = self.rootNavigationController.topViewController;
    if (self.pushMsg != nil && self.pushType != nil) {
        UIViewController *viewController;
        if ([self.pushType isEqualToString:@"01"]) {
            viewController = [[UIStoryboard storyboardWithName:@"News" bundle:nil]instantiateViewControllerWithIdentifier:@"Detail"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            if (!self.pushTitle) {
                self.pushTitle = @"热点新闻";
            }
            [topViewController prepareViewController:viewController withSender:@{@"newsTitle":self.pushTitle,@"newsID":self.pushMsg,@"newsDate":[df stringFromDate:[NSDate date]]}];
            [self push:viewController];
        }
        if ([self.pushType isEqualToString:@"02"]) {
            viewController = [[FFProgressDetailVC alloc]init];
            [viewController setValue:@"结果公示" forKey:@"titleName"];
            [topViewController prepareViewController:viewController withSender:@{@"id":self.pushMsg,@"type":@1}];
            [self push:viewController];
        }
        if ([self.pushType isEqualToString:@"03"]) {
            /*viewController = [[UIStoryboard storyboardWithName:@"Index" bundle:nil]instantiateViewControllerWithIdentifier:@"Web"];
            if (!self.pushTitle) {
                self.pushTitle = @"推送通知";
            }
            [topViewController prepareViewController:viewController withSender:@{@"title":self.pushTitle,@"url":self.pushMsg,@"offset":@(0-64)}];*/
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.pushMsg]];
        }
        [self clearPush];
    }
}


#pragma mark - Fake Methods

- (void)fakeLogin
{
#if DEBUG
    UIViewController *loggerViewController = [[UIStoryboard storyboardWithName:@"Logger" bundle:nil]  instantiateInitialViewController];
    [[RACScheduler mainThreadScheduler]afterDelay:2 schedule:^{
        
        [self push:loggerViewController];
        [self.indexViewController prepareViewController:loggerViewController withSender:@[@"xxxxxx",@"xxxxxx"]];
    }];
#endif
}

- (void)fakePush
{
#if DEBUG
    [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:@{
        @"aps": @{
            @"alert":@"哈喽，普氏·诺提费什！",
            @"badge":@1,
            @"sound":@"default"
        },
        @"pushtype":@"03",
        @"msg":@"http://pages.fangqiuming.com"
    }];
#endif
}
@end
