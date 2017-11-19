//
//  SSTimerViewController.m
//  SecretSpy
//
//  Created by Christ on 11/16/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "SSTimerViewController.h"

@interface SSTimerViewController ()

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSUInteger remainingCounts;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@end

@implementation SSTimerViewController

- (instancetype)initWithTimeInterval:(NSUInteger)timeInterval {
    self = [self init];
    if (self) {
        self.remainingCounts = timeInterval;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)startTimer:(id)sender {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(countDown)
                                                userInfo:nil
                                                 repeats:YES];
    [self countDown];
}

- (void)countDown {
    if (self.remainingCounts-- == -1) {
        self.timerLabel.text = @"Time is out";
        [self.timer invalidate];
        return;
    }
    int minutes = (int)self.remainingCounts / 60;
    int seconds = (int)self.remainingCounts % 60;
    self.timerLabel.text = [NSString stringWithFormat:@"%i : %i", minutes, seconds];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
