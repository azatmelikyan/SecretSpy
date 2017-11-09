//
//  SSGameContainerViewController.h
//  SecretSpy
//
//  Created by User on 11/8/17.
//  Copyright © 2017 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSGameSession.h"

@interface SSGameContainerViewController : UIViewController

- (instancetype)initWithGameSession:(SSGameSession *)session;

@end
