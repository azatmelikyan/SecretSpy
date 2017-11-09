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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.startGameButton setTitle:NSLocalizedString(@"start_game", nil) forState:UIControlStateNormal];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startGameClick:(id)sender {
    SSGameSession *gameSession = [[SSGameSession alloc] initWithPlayersCount:7 spyCount:1];
    SSGameContainerViewController *vc = [[SSGameContainerViewController alloc] initWithGameSession:gameSession];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
