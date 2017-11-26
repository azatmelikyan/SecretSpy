//
//  SCParalaxBehavior.m
//  picsart
//
//  Created by Arman Margaryan on 5/2/15.
//  Copyright (c) 2015 Socialin Inc. All rights reserved.
//

#import "SCParalaxBehavior.h"

@interface SCParalaxBehavior ()

@property (nonatomic, strong) UIView* view;

@end

@implementation SCParalaxBehavior

- (id)initWithTargetView:(UIView *)view {
    self = [super init];
    if (self) {
        self.view = view;
        self.enabled = YES;
    }
    return self;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    _scrollView = scrollView;
    [_scrollView addObserver:self
                  forKeyPath:@"contentOffset"
                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                     context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"contentOffset"] && self.enabled) {
        CGPoint offset = self.scrollView.contentOffset;
        
        if (offset.y > 0) {
            self.view.transform = CGAffineTransformIdentity;
            CGRect frame = CGRectMake(0,  offset.y / 2, self.view.bounds.size.width, self.view.bounds.size.height );
            
            CAShapeLayer* imageViewMaskLayer = [CAShapeLayer new];
            CGRect maskPath = frame;
            maskPath.origin.y = 0;
            maskPath.size.height -= offset.y / 2;
            //TODO
            maskPath.size.width = 1100;
            imageViewMaskLayer.path = [UIBezierPath bezierPathWithRect:maskPath].CGPath;
            
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.view.layer.mask = imageViewMaskLayer;
            [CATransaction commit];
            
            self.view.frame = frame;
        } else {
            float coverH = self.view.bounds.size.height;
            float s = 1;
            if (coverH != 0) {
                s = (coverH - offset.y) / coverH;
            }
            self.view.layer.mask = nil;
            
            self.view.transform = CGAffineTransformMakeScale(s, s);
            self.view.center = CGPointMake(self.view.center.x, self.view.bounds.size.height / 2
                                        + (self.view.bounds.size.height - self.view.frame.size.height) / 2);
        }

    }
}

//- (void)

- (void)dealloc {
    self.scrollView = nil;
}

@end
