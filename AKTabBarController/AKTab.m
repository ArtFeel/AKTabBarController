// AKTab.m
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

#import "AKTab.h"
#import "LKBadgeView.h"

#define kBadgeMargin 3

// cross fade animation duration.
static const float kAnimationDuration = 0.15;

// Padding of the content
static const float kPadding = 0.0;

// Margin between the image and the title
static const float kMargin = 0.0;

// Margin at the top
static const float kTopMargin = 0.0;

@interface AKTab ()

// Permits the cross fade animation between the two images, duration in seconds.
- (void)animateContentWithDuration:(CFTimeInterval)duration;

@property (nonatomic, strong) LKBadgeView *badgeView;

@end

@implementation AKTab

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundColor = [UIColor clearColor];
        [self initBadge];
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)initBadge {
    self.badgeView = [[LKBadgeView alloc] initWithFrame:CGRectZero];
    self.badgeView.widthMode = LKBadgeViewWidthModeSmall;
    self.badgeView.badgeColor = [UIColor redColor];
    self.badgeView.textColor = [UIColor whiteColor];
    self.badgeView.outline = YES;
    self.badgeView.outlineWidth = 1;
    self.badgeView.outlineColor = [UIColor whiteColor];
    [self addSubview:self.badgeView];
}

#pragma mark - Touche handeling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self animateContentWithDuration:kAnimationDuration];
}

#pragma mark - Animation

- (void)animateContentWithDuration:(CFTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contents"];
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:@"contents"];
    [self setNeedsDisplay];
}

#pragma mark - Badge value 

- (void)setBadgeValue:(NSUInteger)badgeValue {
    _badgeValue = badgeValue;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    
    rect.origin.y = rect.origin.y + self.shaddowOffset;
    rect.size.height = rect.size.height - self.shaddowOffset;
    
    UIImage *image = [UIImage imageNamed:(self.selected)? self.activeIconName:self.inactiveIconName];
    CGRect imageRect = CGRectZero;
    
    imageRect.origin.x = floorf(CGRectGetMidX(rect) - image.size.width / 2);
    imageRect.origin.y = floorf(CGRectGetMidY(rect) - image.size.height / 2) + self.shaddowOffset;
    imageRect.size = image.size;

    //active tile has inner gradient (it should be like this)
    CGRect activeRect = rect;
    activeRect.size.width = activeRect.size.width + 8;
    activeRect.origin.x = activeRect.origin.x - 4;
    
    //design issues small hacks
    if (self.frame.origin.x == 0) {
        rect.origin.x -= 1;
        rect.size.width += 1;
    }
    if (self.frame.origin.x >= 4*rect.size.width) {
        NSLog(@"Tu sam %@", NSStringFromCGRect(self.frame));
        rect.size.width += 1;
    }
    
    //draw images
    [[UIImage imageNamed:(self.selected)? self.activeBackgroundImageName:self.inactiveBackgroundImageName] drawInRect:(self.selected)? activeRect:rect];
    [image drawInRect:imageRect];

    if (self.badgeValue == 0) {
        self.badgeView.alpha = 0;
    } else {
        self.badgeView.alpha = 1;
        self.badgeView.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height/2);
        self.badgeView.center = CGPointMake(CGRectGetMaxX(self.bounds) - self.bounds.size.width/4, kBadgeMargin + self.bounds.size.height/4);
        self.badgeView.text = @(3).stringValue;
    }
}
@end