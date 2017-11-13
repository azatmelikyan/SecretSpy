//
//  SSGameContainerViewController.m
//  SecretSpy
//
//  Created by User on 11/8/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "SSGameContainerViewController.h"

@interface SSGameContainerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAndHideButton;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) int remainingCounts;


@property (nonatomic) SSGameSession *gameSession;

@end

@implementation SSGameContainerViewController

- (instancetype)initWithGameSession:(SSGameSession *)session {
    self = [super init];
    if (self) {
        self.gameSession = session;
        self.remainingCounts = 70;
    }
    return self;
}

- (void)countDown {
    if (--self.remainingCounts == 0) {
        [self.timer invalidate];
    }
    int minutes = self.remainingCounts / 60;
    int seconds = self.remainingCounts % 60;
    self.wordLabel.text = [NSString stringWithFormat:@"%i : %i", minutes, seconds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerLabel.text = @"Player 1";
    self.wordLabel.hidden = YES;
    self.wordLabel.text = [self.gameSession nextWord];
    [self.showAndHideButton setTitle:@"Show" forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showAndHideClick:(UIButton *)sender {

    self.wordLabel.hidden = !self.wordLabel.hidden;
    
    if (self.wordLabel.hidden) {
        if (self.gameSession.currentPlayerIndex == self.gameSession.players.count) {
            self.playerLabel.text = @"Timer";
            [sender setTitle:@"Start Timer" forState:UIControlStateNormal];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:2
                                                          target:self
                                                        selector:@selector(countDown)
                                                        userInfo:nil
                                                         repeats:YES];
            self.wordLabel.hidden = NO;
            sender.hidden = YES;
            return;
        }
        
        [sender setTitle:@"Show" forState:UIControlStateNormal];
        self.playerLabel.text = [NSString stringWithFormat:@"Player %lu",(unsigned long)self.gameSession.currentPlayerIndex + 1];
        self.wordLabel.text = [self.gameSession nextWord];
    } else {
        [sender setTitle:@"Hide" forState:UIControlStateNormal];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
