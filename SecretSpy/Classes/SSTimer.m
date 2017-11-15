//
//  SSTimer.m
//  SecretSpy
//
//  Created by User on 11/13/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "SSTimer.h"
#import <QuartzCore/CADisplayLink.h>

@implementation SSTimer

- (id) init {
    self = [super init];
    if (self != nil) {
        start = nil;
        end = nil;
    }
    return self;
}

- (void) startTimer {
    start = [NSDate date];
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerFired:)];
    displayLink.preferredFramesPerSecond = 10;
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void) stopTimer {
    end = [NSDate date];
}

- (double) timeElapsedInSeconds {
    return [end timeIntervalSinceDate:start];
}

- (double) timeElapsedInMilliseconds {
    return [self timeElapsedInSeconds] * 1000.0f;
}

- (double) timeElapsedInMinutes {
    return [self timeElapsedInSeconds] / 60.0f;
}

- (void)timerFired:(CADisplayLink *)link {
    
}

@end
