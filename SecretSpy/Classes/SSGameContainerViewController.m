//
//  SSGameContainerViewController.m
//  SecretSpy
//
//  Created by User on 11/8/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "SSGameContainerViewController.h"
#import "SSTimerViewController.h"
#import "SSLanguageManager.h"

@interface SSGameContainerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAndHideButton;
@property (weak, nonatomic) IBOutlet UIView *wordBackgroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wordBackgroundViewHeightConstraint;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainOfCurentPlayerLbl;
    

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
    UIFont *font = [UIFont systemFontOfSize:20];
    [self.playerLabel setFont:font];
    self.playerLabel.adjustsFontSizeToFitWidth = YES;
    NSString *countString = [NSString stringWithFormat:@"%lu / %lu", self.gameSession.currentPlayerIndex + 1, (unsigned long)self.gameSession.players.count];
    self.playerLabel.text = [NSString stringWithFormat:[[SSLanguageManager sharedInstance] localizedString:@"player_number"], countString];
//    self.wordLabel.hidden = YES;
    self.wordLabel.text = [self.gameSession nextWord];
    [self.showAndHideButton setTitle:[[SSLanguageManager sharedInstance] localizedString:@"show"] forState:UIControlStateNormal];
    self.wordBackgroundViewHeightConstraint.constant = 0;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showAndHideClick:(UIButton *)sender {

    if (self.wordBackgroundViewHeightConstraint.constant != 0) {
        if (self.gameSession.currentPlayerIndex == self.gameSession.players.count) {
//            self.playerLabel.text = @"Ready to Start";
//            [sender setTitle:@"Start Timer" forState:UIControlStateNormal];
//            self.wordLabel.hidden = YES;
            SSTimerViewController *timerController = [[SSTimerViewController alloc] initWithTimeInterval:self.gameSession.timeInterval resultString:[self.gameSession resultsString]];
            [self.navigationController pushViewController:timerController animated:YES];
            return;
        }
        [sender setTitle:[[SSLanguageManager sharedInstance] localizedString:@"show"] forState:UIControlStateNormal];
        NSString *countString = [NSString stringWithFormat:@"%lu / %lu", self.gameSession.currentPlayerIndex + 1, (unsigned long)self.gameSession.players.count];
        self.playerLabel.text = [NSString stringWithFormat:[[SSLanguageManager sharedInstance] localizedString:@"player_number"], countString];
        self.wordLabel.text = [self.gameSession nextWord];
//        self.wordLabel.hidden = !self.wordLabel.hidden;
        [self hide];
    } else {
        
        [sender setTitle:[[SSLanguageManager sharedInstance] localizedString:@"hide"] forState:UIControlStateNormal];
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
