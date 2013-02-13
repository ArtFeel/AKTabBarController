// AKTabBarController.h
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

#import "AKTabBarView.h"
#import "AKTabBar.h"
#import "AKTab.h"

@interface AKTabBarController : UIViewController <AKTabBarDelegate, UINavigationControllerDelegate>

// View Controllers handled by the tab bar controller.
@property (nonatomic, strong) NSMutableArray *viewControllers;

// This is the minimum height to display the title.
@property (nonatomic, assign) CGFloat minimumHeightToDisplayTitle;

// Tab bar background image
@property (nonatomic, strong) NSString *tabBarBackgroundImageName;

// Tab background image
@property (nonatomic, strong) NSString *tabBackgroundImageName;

// Tab selected background image
@property (nonatomic, strong) NSString *tabSelectedBackgroundImageName;

// Tab text color
@property (nonatomic, strong) UIColor *textColor;

// Tab selected text color
@property (nonatomic, strong) UIColor *selectedTextColor;

// Tab shaddow offset
@property (nonatomic, assign) NSUInteger shaddowOffset;

// Initialization with a specific height.
- (id)initWithTabBarHeight:(NSUInteger)height;

@end
