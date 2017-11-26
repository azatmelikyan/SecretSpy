//
//  SCParalaxBehavior.h
//  picsart
//
//  Created by Arman Margaryan on 5/2/15.
//  Copyright (c) 2015 Socialin Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCParalaxBehavior : NSObject

- (id)initWithTargetView:(UIView*)view;

@property (nonatomic, strong) UIScrollView* scrollView;

@property (nonatomic) BOOL enabled;

@end
