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

// cross fade animation duration.
static const float kAnimationDuration = 0.15;

// Padding of the content
static const float kPadding = 4.0;

// Margin between the image and the title
static const float kMargin = 2.0;

// Margin at the top
static const float kTopMargin = 2.0;

@interface AKTab ()

// Permits the cross fade animation between the two images, duration in seconds.
- (void)animateContentWithDuration:(CFTimeInterval)duration;

@end

@implementation AKTab

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
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

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{

    NSLog(@"Crtam tab u rectu %@", NSStringFromCGRect(rect));
    
    rect.origin.y = rect.origin.y + self.shaddowOffset;
    rect.size.height = rect.size.height - self.shaddowOffset;
    
    // Container, basically centered in rect
    CGRect container = CGRectInset(rect, kPadding, kPadding);
    container.size.height -= kTopMargin;
    container.origin.y += kTopMargin;
    
    UIImage *image = [UIImage imageNamed:(self.selected)? self.activeIconName:self.inActiveIconName];
    CGRect imageRect = CGRectZero;
    CGFloat ratio = 0;
    
    // Getting the ratio for eventual scaling
    ratio = image.size.width / image.size.height;
    
    // Setting the imageContainer's size.
    imageRect.size = image.size;
    
    // Container of the image + label (when there is room)
    CGRect content = CGRectZero;
    content.size.width = CGRectGetWidth(container);
    
    // We determine the height based on the longest side of the image (when not square) , presence of the label and height of the container
    content.size.height = MIN(MAX(CGRectGetWidth(imageRect), CGRectGetHeight(imageRect)), CGRectGetHeight(container));
    
    // Now we move the boxes
    content.origin.x = floorf(CGRectGetMidX(container) - CGRectGetWidth(content) / 2);
    content.origin.y = floorf(CGRectGetMidY(container) - CGRectGetHeight(content) / 2);
    
    CGRect imageContainer = content;
    imageContainer.size.height = CGRectGetHeight(content);
    
    // When the image is not square we have to make sure it will not go beyond the bonds of the container
    if (CGRectGetWidth(imageRect) >= CGRectGetHeight(imageRect)) {
        imageRect.size.width = MIN(CGRectGetHeight(imageRect), MIN(CGRectGetWidth(imageContainer), CGRectGetHeight(imageContainer)));
        imageRect.size.height = floorf(CGRectGetWidth(imageRect) / ratio);
    } else {
        imageRect.size.height = MIN(CGRectGetHeight(imageRect), MIN(CGRectGetWidth(imageContainer), CGRectGetHeight(imageContainer)));
        imageRect.size.width = floorf(CGRectGetHeight(imageRect) * ratio);
    }
    
    imageRect.origin.x = floorf(CGRectGetMidX(content) - CGRectGetWidth(imageRect) / 2);
    imageRect.origin.y = floorf(CGRectGetMidY(imageContainer) - CGRectGetHeight(imageRect) / 2) + self.shaddowOffset;
    imageRect.size.height = imageRect.size.height - self.shaddowOffset;
    
    //draw images
    [[UIImage imageNamed:(self.selected)? self.activeBackgroundImageName:self.inActiveBackgroundImageName] drawInRect:rect];
    [image drawInRect:imageRect];
    
    
}
@end