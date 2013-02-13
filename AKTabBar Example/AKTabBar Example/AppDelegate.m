//
//  AppDelegate.m
//  AKTabBar Example
//
//  Created by Ali KARAGOZ on 03/05/12.
//  Copyright (c) 2012 Ali Karagoz. All rights reserved.
//

#import "AppDelegate.h"
#import "AKTabBarController.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "TestViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // If the device is an iPad, we make it taller.
    _tabBarController = [[TestViewController alloc] initWithTabBarHeight:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 70 : 52];
//    [_tabBarController setMinimumHeightToDisplayTitle:52];
//    [_tabBarController setShaddowOffset:3];
//    
//    FirstViewController *tableViewController = [[FirstViewController alloc] initWithStyle:UITableViewStylePlain];
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
//    navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
//    
//    [_tabBarController setViewControllers:[NSMutableArray arrayWithObjects:
//                                               navigationController,
//                                               [[SecondViewController alloc] init],
//                                               [[ThirdViewController alloc] init],
//                                               [[FourthViewController alloc] init],[[FourthViewController alloc] init],nil]];
//    
//    
//    // Below you will find an example of possible customization, just uncomment the lines
//    
//    
//    // Tab background Image
//    [_tabBarController setBackgroundImageName:@"footer_bg"];
    
    [_window setRootViewController:_tabBarController];
    [_window makeKeyAndVisible];
    return YES;
}

@end
