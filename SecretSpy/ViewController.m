//
//  ViewController.m
//  SecretSpy
//
//  Created by User on 11/6/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "ViewController.h"
#import "SSGameContainerViewController.h"
#import "SSRulesViewController.h"
#import "VLDContextSheet.h"
#import "VLDContextSheetItem.h"

@interface ViewController () <VLDContextSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UILabel *playersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *spyCountLabel;
@property (weak, nonatomic) IBOutlet UIView *languageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *currentLanguageImageView;

@property (nonatomic) VLDContextSheet *contextSheet;
@property (nonatomic) NSUInteger playersCount;
@property (nonatomic) NSUInteger spyCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self createContextSheet];
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
    [self.navigationController pushViewController:vc animated:YES];
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

- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (IBAction)infoButtonClicked:(id)sender {
    SSRulesViewController *vc = [[SSRulesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)createContextSheet {
    VLDContextSheetItem *item1 = [[VLDContextSheetItem alloc] initWithTitle: @"English"
                                                                      image: [UIImage imageNamed: @"ic_flag_england"]
                                                           highlightedImage: [UIImage imageNamed: @"ic_flag_england"]];
    
    
    VLDContextSheetItem *item2 = [[VLDContextSheetItem alloc] initWithTitle: @"Armenian"
                                                                      image: [UIImage imageNamed: @"ic_flag_armenia"]
                                                           highlightedImage: [UIImage imageNamed: @"ic_flag_armenia"]];
    
    VLDContextSheetItem *item3 = [[VLDContextSheetItem alloc] initWithTitle: @"Russian"
                                                                      image: [UIImage imageNamed: @"ic_flag_russia"]
                                                           highlightedImage: [UIImage imageNamed: @"ic_flag_russia"]];
    
    self.contextSheet = [[VLDContextSheet alloc] initWithItems: @[ item1, item2, item3 ]];
    self.contextSheet.delegate = self;
    UIGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self
                                                                                           action: @selector(longPressed:)];
    [self.languageContainerView addGestureRecognizer: gestureRecognizer];
}

- (void)contextSheet:(VLDContextSheet *)contextSheet didSelectItem:(VLDContextSheetItem *)item {
    [self.currentLanguageImageView setImage:item.image];
}

- (void) longPressed: (UIGestureRecognizer *) gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        [self.contextSheet startWithGestureRecognizer: gestureRecognizer
                                               inView: self.view];
    }
}

- (void)setup {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    [UINavigationBar appearance].shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    [UINavigationBar appearance].translucent = YES;
}
@end
