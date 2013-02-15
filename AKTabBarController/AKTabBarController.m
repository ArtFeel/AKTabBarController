// AKTabBarController.m
//
// Copyright (c) 2012 Ali Karagoz (http://alikaragoz.net)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AKTabBarController.h"
#import "UIViewController+AKTabBarController.h"


// Default height of the tab bar
static const int kDefaultTabBarHeight = 52;

// Default Push animation duration
static const float kPushAnimationDuration = 0.35;

@interface AKTabBarController ()
{
    NSArray *prevViewControllers;
    BOOL visible;
}

typedef enum {
    AKShowHideFromLeft,
    AKShowHideFromRight
} AKShowHideFrom;

- (void)loadTabs;
- (void)showTabBar:(AKShowHideFrom)showHideFrom animated:(BOOL)animated;
- (void)hideTabBar:(AKShowHideFrom)showHideFrom animated:(BOOL)animated;

@end

@implementation AKTabBarController
{
    // Bottom tab bar view
    AKTabBar *tabBar;
    
    // Content view
    AKTabBarView *tabBarView;

}

- (CGRect)contentViewFrame {
    return tabBarView.contentView.frame;
}

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    // Setting the default tab bar height
    self.tabBarHeight = kDefaultTabBarHeight;
    
    return self;
}

- (id)initWithTabBarHeight:(NSUInteger)height
{
    self = [super init];
    if (!self) return nil;
    
    self.tabBarHeight = height;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Creating and adding the tab bar view
    tabBarView = [[AKTabBarView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = tabBarView;
    
    // Creating and adding the tab bar
    CGRect tabBarRect = CGRectMake(0.0, CGRectGetHeight(self.view.bounds) - self.tabBarHeight, CGRectGetWidth(self.view.frame), self.tabBarHeight);
    tabBar = [[AKTabBar alloc] initWithFrame:tabBarRect];
    tabBar.delegate = self;
    tabBar.shaddowOffset = self.shaddowOffset;
    
    tabBarView.tabBar = tabBar;
    tabBarView.shaddowOffset = self.shaddowOffset;
    tabBarView.contentView = _selectedViewController.view;
    [[self navigationItem] setTitle:[_selectedViewController title]];
    [self loadTabs];

}

- (void)loadTabs
{
    NSMutableArray *tabs = [[NSMutableArray alloc] init];
    for (UIViewController *vc in self.viewControllers)
    {
        [[tabBarView tabBar] setBackgroundImageName:[self tabBarBackgroundImageName]];
        
        AKTab *tab = [[AKTab alloc] init];
        
        tab.shaddowOffset = self.shaddowOffset;

        tab.activeIconName = [vc tabActiveImageName];
        tab.inactiveIconName = [vc tabInactiveImageName];
        
        tab.activeBackgroundImageName = self.tabSelectedBackgroundImageName;
        tab.inactiveBackgroundImageName = self.tabBackgroundImageName;

        tab.tabBarHeight = self.tabBarHeight;

        if ([[vc class] isSubclassOfClass:[UINavigationController class]])
            ((UINavigationController *)vc).delegate = self;
        
        [tabs addObject:tab];
    }
    
    [tabBar setTabs:tabs];
    
    // Setting the first view controller as the active one
    [tabBar setSelectedTab:[tabBar.tabs objectAtIndex:0]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [tabBar setSelectedTab:[tabBar.tabs objectAtIndex:selectedIndex]];
    _selectedIndex = selectedIndex;
}

#pragma mark - Badge setup

- (void)setBadgeValue:(NSInteger)badgeValue onTab:(NSInteger)tabIndex {
    if (tabIndex >= 0 && tabIndex < tabBar.tabs.count) {
        [(AKTab *)[tabBar.tabs objectAtIndex:tabIndex] setBadgeValue:badgeValue];
    }
}

#pragma - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!prevViewControllers)
        prevViewControllers = [navigationController viewControllers];
    
    
    // We detect is the view as been push or popped
    BOOL pushed;
    
    if ([prevViewControllers count] <= [[navigationController viewControllers] count])
        pushed = YES;
    else
        pushed = NO;
    
    // Logic to know when to show or hide the tab bar
    BOOL isPreviousHidden, isNextHidden;
    
    isPreviousHidden = [[prevViewControllers lastObject] hidesBottomBarWhenPushed];
    isNextHidden = [viewController hidesBottomBarWhenPushed];
    
    prevViewControllers = [navigationController viewControllers];
    
    if (!isPreviousHidden && !isNextHidden)
        return;
    
    else if (!isPreviousHidden && isNextHidden)
        [self hideTabBar:(pushed ? AKShowHideFromRight : AKShowHideFromLeft) animated:animated];
    
    else if (isPreviousHidden && !isNextHidden)
        [self showTabBar:(pushed ? AKShowHideFromRight : AKShowHideFromLeft) animated:animated];
    
    else if (isPreviousHidden && isNextHidden)
        return;
    

    if ([viewController respondsToSelector:@selector(updateLayout:)]) {
        [viewController performSelector:@selector(updateLayout:) withObject:@(tabBarView.bounds.size.height - viewController.navigationController.navigationBar.frame.size.height)];
    }

}

- (void)showTabBar:(AKShowHideFrom)showHideFrom animated:(BOOL)animated
{
    
    CGFloat directionVector;
    
    switch (showHideFrom) {
        case AKShowHideFromLeft:
            directionVector = -1.0;
            break;
        case AKShowHideFromRight:
            directionVector = 1.0;
            break;
        default:
            break;
    }
    
    tabBar.hidden = NO;
    tabBar.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds) * directionVector, 0);
    // when the tabbarview is resized we can see the view behind
    
    [UIView animateWithDuration:((animated) ? kPushAnimationDuration : 0) animations:^{
        tabBar.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        tabBarView.isTabBarHidding = NO;
        [tabBarView setNeedsLayout];
    }];
}

- (void)hideTabBar:(AKShowHideFrom)showHideFrom animated:(BOOL)animated
{
    
    CGFloat directionVector;
    switch (showHideFrom) {
        case AKShowHideFromLeft:
            directionVector = 1.0;
            break;
        case AKShowHideFromRight:
            directionVector = -1.0;
            break;
        default:
            break;
    }
    
    tabBarView.isTabBarHidding = YES;
    
    CGRect tmpTabBarView = tabBarView.contentView.frame;
    tmpTabBarView.size.height = tabBarView.bounds.size.height;
    tabBarView.contentView.frame = tmpTabBarView;
    
    [UIView animateWithDuration:((animated) ? kPushAnimationDuration : 0) animations:^{
        tabBar.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds) * directionVector, 0);
    } completion:^(BOOL finished) {
        tabBar.hidden = YES;
        tabBar.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - Setters

- (void)setViewControllers:(NSMutableArray *)viewControllers
{
    _viewControllers = viewControllers;
    
    // When setting the view controllers, the first vc is the selected one;
    [self setSelectedViewController:[viewControllers objectAtIndex:0]];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    UIViewController *previousSelectedViewController = selectedViewController;
    if (_selectedViewController != selectedViewController)
    {
        
        _selectedViewController = selectedViewController;
        selectedViewController = selectedViewController;
        
        if (!self.childViewControllers && visible)
        {
			[previousSelectedViewController viewWillDisappear:NO];
			[selectedViewController viewWillAppear:NO];
		}
        
        [tabBarView setContentView:selectedViewController.view];
        
        if (!self.childViewControllers && visible)
        {
			[previousSelectedViewController viewDidDisappear:NO];
			[selectedViewController viewDidAppear:NO];
		}
        
        [tabBar setSelectedTab:[tabBar.tabs objectAtIndex:[self.viewControllers indexOfObject:selectedViewController]]];
    }
}


#pragma mark - Required Protocol Method

- (void)tabBar:(AKTabBar *)AKTabBarDelegate didSelectTabAtIndex:(NSInteger)index
{
    UIViewController *vc = [self.viewControllers objectAtIndex:index];
    
    if (self.selectedViewController == vc)
    {
        if ([vc isKindOfClass:[UINavigationController class]])
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [[self navigationItem] setTitle:[vc title]];
        self.selectedViewController = vc;
    }
}

#pragma mark - Rotation Events

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    // Redraw with will rotating and keeping the aspect ratio
    for (AKTab *tab in [tabBar tabs])
        [tab setNeedsDisplay];
    
    [self.selectedViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark - ViewController Life cycle

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewDidAppear:animated];
    
    visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    if (![self respondsToSelector:@selector(addChildViewController:)])
        [self.selectedViewController viewDidDisappear:animated];
    
    visible = NO;
}

@end