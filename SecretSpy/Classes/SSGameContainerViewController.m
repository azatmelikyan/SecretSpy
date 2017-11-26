//
//  SSGameContainerViewController.m
//  SecretSpy
//
//  Created by User on 11/8/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "SSGameContainerViewController.h"
#import "SSTimerViewController.h"

@interface SSGameContainerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAndHideButton;
@property (weak, nonatomic) IBOutlet UIView *wordBackgroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wordBackgroundViewHeightConstraint;


@property (nonatomic) SSGameSession *gameSession;

@end

@implementation SSGameContainerViewController

- (instancetype)initWithGameSession:(SSGameSession *)session {
    self = [super init];
    if (self) {
        self.gameSession = session;
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerLabel.text = @"Player 1";
//    self.wordLabel.hidden = YES;
    self.wordLabel.text = [self.gameSession nextWord];

    [self.showAndHideButton setTitle:@"Show" forState:UIControlStateNormal];
    self.wordBackgroundViewHeightConstraint.constant = 0;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showAndHideClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Show the result"]) {
        NSArray *result = [self.gameSession finishGame];
        NSString *reslutString = @"";
        for (int i = 0; i < result.count; i++) {
            NSNumber *index = result[i];
            int i = [index intValue] + 1;
            reslutString = [reslutString stringByAppendingString:[NSString stringWithFormat:@"  %i", i]];
        }
        self.wordLabel.text = [NSString stringWithFormat:@"Spy index: %@", reslutString];
        sender.hidden = YES;
        return;
    }
    if (self.wordBackgroundViewHeightConstraint.constant != 0) {
        if (self.gameSession.currentPlayerIndex == self.gameSession.players.count) {
//            self.playerLabel.text = @"Ready to Start";
//            [sender setTitle:@"Start Timer" forState:UIControlStateNormal];
//            self.wordLabel.hidden = YES;
            SSTimerViewController *timerController = [[SSTimerViewController alloc] initWithTimeInterval:self.gameSession.timeInterval];
            [self.navigationController pushViewController:timerController animated:YES];
            return;
        }
        [sender setTitle:@"Show" forState:UIControlStateNormal];
        self.playerLabel.text = [NSString stringWithFormat:@"Player %lu",(unsigned long)self.gameSession.currentPlayerIndex + 1];
        self.wordLabel.text = [self.gameSession nextWord];
//        self.wordLabel.hidden = !self.wordLabel.hidden;
        [self hide];
    } else {
        if ([sender.titleLabel.text isEqualToString:@"Start Timer"]) {
           
            
            [sender setTitle:@"Show the result" forState:UIControlStateNormal];
            return;
        }
        
        [sender setTitle:@"Hide" forState:UIControlStateNormal];
//        self.wordLabel.hidden = !self.wordLabel.hidden;
        [self show];
    }
}

- (void)hide {
    self.wordBackgroundViewHeightConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)show {
    self.wordBackgroundViewHeightConstraint.constant = 70;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
