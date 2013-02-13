//
//  TestViewController.m
//  AKTabBar Example
//
//  Created by Slavko Krucaj on 2/12/13.
//  Copyright (c) 2013 Ali Karagoz. All rights reserved.
//

#import "TestViewController.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    [self setMinimumHeightToDisplayTitle:52];
    [self setShaddowOffset:2];
    
    FirstViewController *tableViewController = [[FirstViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    [self setViewControllers:[NSMutableArray arrayWithObjects:
                              navigationController,
                              [[SecondViewController alloc] init],
                              [[ThirdViewController alloc] init],
                              [[FourthViewController alloc] init],[[FourthViewController alloc] init],nil]];
    
    [self setTabBackgroundImageName:@"tile_inactive"];
    [self setTabSelectedBackgroundImageName:@"tile_active_big"];
    [self setTabBarBackgroundImageName:@"separator"];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
