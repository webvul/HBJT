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

@interface AppDelegate ()

@property (strong, nonatomic) IQKeyboardManager *keyboardManager;
@property (strong, nonatomic) MMDrawerController *drawerController;
@property (strong, nonatomic) EJIndexViewController *indexViewController;
@property (strong, nonatomic) EJMenuTableViewController *menuTableViewController;
@property (strong, nonatomic) EJNewsViewController *newsViewController;
@property (strong, nonatomic) UINavigationController *rootNavigationController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"App Launching");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.drawerController];
    [self.window makeKeyAndVisible];
    NSLog(@"App Launched");
    [self fakeLogin];
    AppDelegate *delegate = [AppDelegate sharedDelegate];
    NSLog(@"%@",[delegate userAddressString]);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

#pragma mark - Private Methods

- (void)fakeLogin
{
    [self setUsername:@"void" name:@"空" id:@"null" number:@"0" phone:@"invalid" address:@"not found (404)"];
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
        //_rootNavigationController.navigationBar.tintColor = [UIColor colorWithRed:0.169 green:0.518 blue:0.827 alpha:0.1];
    }
    return _rootNavigationController;
}

- (MMDrawerController *)drawerController
{
    if (_drawerController == nil) {
        _drawerController = [[MMDrawerController alloc] initWithCenterViewController:self.rootNavigationController leftDrawerViewController:nil];
        [_drawerController setShowsShadow:NO];
        [_drawerController setMaximumLeftDrawerWidth:240.0];
        [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
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
@end
