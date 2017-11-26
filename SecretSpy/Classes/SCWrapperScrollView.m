//
//  SCWrapperScrollView.m
//  scrollViewWrapper
//
//  Created by Arman Margaryan on 4/22/15.
//  Copyright (c) 2015 Arman Margaryan. All rights reserved.
//

#import "SCWrapperScrollView.h"

@interface SCWrapperScrollView () <UIScrollViewDelegate>

@property (nonatomic) BOOL isIgnoreOffsetChange;

@end

@implementation SCWrapperScrollView

- (void)initialize {
    [self addObserver:self
           forKeyPath:@"contentOffset"
              options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
              context:nil];
}

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setScrollContainerView:(UIView *)scrollContainerView {
    [scrollContainerView removeFromSuperview];
    
    CGRect frame = scrollContainerView.frame;
    frame.origin.y = self.scrollContainerInsets.top;
    scrollContainerView.frame = frame;
    
    _scrollContainerView = scrollContainerView;
    [self insertSubview:_scrollContainerView atIndex:0];
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) return;
    
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    
    _scrollView = scrollView;
    
    _scrollView.scrollEnabled = NO;
    _scrollView.scrollsToTop = NO;
    [_scrollView addObserver:self
                     forKeyPath:@"contentSize"
                        options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                        context:nil];
    [_scrollView addObserver:self
                  forKeyPath:@"contentOffset"
                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                     context:nil];
    
    if (self.contentOffset.y > self.scrollContainerInsets.top) {
        self.contentOffset = CGPointMake(self.contentOffset.x, self.scrollContainerInsets.top);
    }
    [self updateContentSize];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self) {
        [self handleSelfScroll];
        return;
    }
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self updateContentSize];
    } else if ([keyPath isEqualToString:@"contentOffset"] && !self.isIgnoreOffsetChange) {
        CGPoint prevOffset = [change[NSKeyValueChangeOldKey] CGPointValue];
        float diffY = self.scrollView.contentOffset.y - prevOffset.y;
        
        CGPoint offset = self.contentOffset;
        offset.y += diffY;
        self.contentOffset = offset;
    }
}

- (void)updateContentSize {
    float contentH = self.scrollContainerInsets.top + self.scrollView.contentInset.top +
                     self.scrollView.contentInset.bottom + self.scrollView.contentSize.height;
    float minContentHeight = self.scrollContainerInsets.top + self.scrollContainerView.frame.size.height;
    contentH = MAX(minContentHeight, contentH);
    self.contentSize = CGSizeMake(self.scrollView.contentSize.width, contentH);
}

- (void)handleSelfScroll {
    self.isIgnoreOffsetChange = YES;
    
    if (self.contentOffset.y > self.scrollContainerInsets.top) {
        float centerY = self.contentOffset.y + self.scrollContainerView.frame.size.height / 2;
        self.scrollContainerView.center = CGPointMake(self.scrollContainerView.center.x, centerY);
        
        CGPoint offset = self.contentOffset;
        offset.y -= (self.scrollContainerInsets.top + self.scrollView.contentInset.top);
        self.scrollView.contentOffset = offset;
    } else {
        self.scrollView.contentOffset = CGPointMake(0, -self.scrollView.contentInset.top);
        self.scrollContainerView.center = CGPointMake(self.scrollContainerView.center.x,
                                                      self.scrollContainerView.frame.size.height / 2 + self.scrollContainerInsets.top);
    }
    
    self.isIgnoreOffsetChange = NO;
}

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    _scrollView = nil;

    [self removeObserver:self forKeyPath:@"contentOffset"];
}

@end
