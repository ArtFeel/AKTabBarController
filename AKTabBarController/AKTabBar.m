// AKTabBar.m
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

#import "AKTabBar.h"

static int kInterTabMargin = 1;

@implementation AKTabBar

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeRedraw;
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleTopMargin);
    }
    return self;
}

#pragma mark - Setters and Getters

- (void)setTabs:(NSArray *)array
{
    if (_tabs != array) {
        for (AKTab *tab in _tabs) {
            [tab removeFromSuperview];
        }
        
        _tabs = array;
        
        for (AKTab *tab in _tabs) {
            tab.userInteractionEnabled = YES;
            [tab addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchDown];
        }
    }
    [self setNeedsLayout];
}

- (void)setSelectedTab:(AKTab *)selectedTab {
    if (selectedTab != _selectedTab) {
        [_selectedTab setSelected:NO];
        _selectedTab = selectedTab;
        [self tabSelected:selectedTab];
        [_selectedTab setSelected:YES];
    }
}

#pragma mark - Delegate notification

- (void)tabSelected:(AKTab *)sender
{
    [_delegate tabBar:self didSelectTabAtIndex:[_tabs indexOfObject:sender]];
}


#pragma mark - Drawing & Layout

- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:self.backgroundImageName] drawInRect:self.bounds];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat screenWidth = self.bounds.size.width;
    
    CGFloat tabNumber = _tabs.count;
    
    // Calculating the tabs width.
    CGFloat tabWidth = floorf(((screenWidth + 1) / tabNumber) - 1);
    
    // Because of the screen size, it is impossible to have tabs with the same
    // width. Therefore we have to increase each tab width by one until we spend
    // of the spaceLeft counter.
    CGFloat spaceLeft = screenWidth - (tabWidth * tabNumber) - (tabNumber - 1);
    
    CGRect rect = self.bounds;
    rect.size.width = tabWidth;

    CGFloat dTabWith;
    
    for (AKTab *tab in _tabs) {
    
        // Here is the code that increment the width until we use all the space left
        
        dTabWith = tabWidth;
        
        if (spaceLeft != 0) {
            dTabWith = tabWidth + 1;
            spaceLeft--;
        }
        
        if ([_tabs indexOfObject:tab] == 0) {
            tab.frame = CGRectMake(rect.origin.x, rect.origin.y, dTabWith, rect.size.height);
        } else {
            tab.frame = CGRectMake(rect.origin.x + kInterTabMargin, rect.origin.y, dTabWith, rect.size.height);
        }
        
        [self addSubview:tab];
        rect.origin.x = tab.frame.origin.x + tab.frame.size.width;
    }
    
}

@end