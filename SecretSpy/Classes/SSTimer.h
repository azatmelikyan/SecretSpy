//
//  SSTimer.h
//  SecretSpy
//
//  Created by User on 11/13/17.
//  Copyright © 2017 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSTimer : NSObject {
    NSDate *start;
    NSDate *end;
}

- (void) startTimer;
- (void) stopTimer;
- (double) timeElapsedInSeconds;
- (double) timeElapsedInMilliseconds;
- (double) timeElapsedInMinutes;

@end
