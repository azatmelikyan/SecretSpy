//
//  ViewController.m
//  SecretSpy
//
//  Created by User on 11/6/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "ViewController.h"
#import "SSGameContainerViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UILabel *playersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *spyCountLabel;

@property (nonatomic) NSUInteger playersCount;
@property (nonatomic) NSUInteger spyCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.startGameButton setTitle:NSLocalizedString(@"start_game", nil) forState:UIControlStateNormal];
    self.playersCount = 4;
    self.spyCount = 1;
    self.playersCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.playersCount];
    self.spyCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.spyCount];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startGameClick:(id)sender {
    SSGameSession *gameSession = [[SSGameSession alloc] initWithPlayersCount:self.playersCount spyCount:self.spyCount];
    SSGameContainerViewController *vc = [[SSGameContainerViewController alloc] initWithGameSession:gameSession];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)playersMinusClick:(id)sender {
    self.playersCount--;
    self.playersCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.playersCount];
}

- (IBAction)playersPlusClick:(id)sender {
    self.playersCount++;
    self.playersCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.playersCount];
}

- (IBAction)spyMinusClick:(id)sender {
    self.spyCount--;
    self.spyCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.spyCount];
}

- (IBAction)slyPlusClick:(id)sender {
    self.spyCount++;
    self.spyCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.spyCount];
}



- (void)setPlayersCount:(NSUInteger)playersCount {
    if (playersCount >= 3 && playersCount < 20) {
        _playersCount = playersCount;
    }
}

- (void)setSpyCount:(NSUInteger)spyCount {
    if (spyCount > 0 && spyCount <= self.playersCount) {
        _spyCount = spyCount;
    }
}








@end
