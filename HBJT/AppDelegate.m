//
//  AppDelegate.m
//  hbjt
//
//  Created by 方秋鸣 on 16/2/24.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"App Launching");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.drawerController];
    [self.window makeKeyAndVisible];
    NSLog(@"App Launched");
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

- (void)setLeftDrawerViewController
{
    if (!self.drawerController.leftDrawerViewController) {
        [self.drawerController setLeftDrawerViewController:self.menuTableViewController];
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



#pragma mark - Getters

- (NSMutableDictionary *)userinfo
{
    if (_userinfo == nil) {
        _userinfo = [[NSMutableDictionary alloc]init];
        [_userinfo setValue:@(NO) forKey:@"isCurrentUser"];
    }
    return _userinfo;
}


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
