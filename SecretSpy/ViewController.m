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
#import "SSLanguageManager.h"

@interface ViewController () <VLDContextSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UILabel *playersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *spyCountLabel;
@property (weak, nonatomic) IBOutlet UIView *languageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *currentLanguageImageView;

@property (nonatomic) VLDContextSheet *contextSheet;
@property (nonatomic) NSUInteger detectivesCount;
@property (nonatomic) NSUInteger spyCount;
@property (nonatomic) NSUInteger timeInterval;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self createContextSheet];
    [self.startGameButton setTitle:[[SSLanguageManager sharedInstance] localizedString:@"start_game"] forState:UIControlStateNormal];
    self.startGameButton.layer.borderWidth = 3;
    self.startGameButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.detectivesCount = 3;
    self.spyCount = 1;
    self.timeInterval = 7;
    self.playersCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.detectivesCount];
    self.spyCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.spyCount];
    [self setupLanguge];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLanguageChange:) name:kSCNotificationLanguageChanged object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startGameClick:(id)sender {
    SSGameSession *gameSession = [[SSGameSession alloc] initWithPlayersCount:[self playersCount] spyCount:self.spyCount timeInMinutes:self.timeInterval];
    SSGameContainerViewController *vc = [[SSGameContainerViewController alloc] initWithGameSession:gameSession];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)playersMinusClick:(id)sender {
    self.detectivesCount--;
    self.playersCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.detectivesCount];
}

- (IBAction)playersPlusClick:(id)sender {
    self.detectivesCount++;
    self.playersCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.detectivesCount];
}

- (IBAction)spyMinusClick:(id)sender {
    self.spyCount--;
    self.spyCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.spyCount];
}

- (IBAction)slyPlusClick:(id)sender {
    self.spyCount++;
    self.spyCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.spyCount];
}



- (void)setDetectivesCount:(NSUInteger)detectivesCount {
    if (detectivesCount >= 3 && [self playersCount] < 20) {
        _detectivesCount = detectivesCount;
    }
}

- (void)setSpyCount:(NSUInteger)spyCount {
    if (spyCount > 0 && [self playersCount] < 20) {
        _spyCount = spyCount;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (IBAction)infoButtonClicked:(id)sender {
    SSRulesViewController *vc = [[SSRulesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSUInteger)playersCount {
    return self.detectivesCount + self.spyCount;
}

- (void)createContextSheet {
    VLDContextSheetItem *item1 = [[VLDContextSheetItem alloc] initWithTitle: @"English"
                                                                      image: [UIImage imageNamed: @"ic_flag_england"]
                                                           highlightedImage: [UIImage imageNamed: @"ic_flag_england"]
                                                               languageCode: kSCEnglish];
    
    
    VLDContextSheetItem *item2 = [[VLDContextSheetItem alloc] initWithTitle: @"Armenian"
                                                                      image: [UIImage imageNamed: @"ic_flag_armenia"]
                                                           highlightedImage: [UIImage imageNamed: @"ic_flag_armenia"]
                                                               languageCode: kSCArmenian];
    
    VLDContextSheetItem *item3 = [[VLDContextSheetItem alloc] initWithTitle: @"Russian"
                                                                      image: [UIImage imageNamed: @"ic_flag_russia"]
                                                           highlightedImage: [UIImage imageNamed: @"ic_flag_russia"]
                                                               languageCode: kSCRussian];
    
    self.contextSheet = [[VLDContextSheet alloc] initWithItems: @[ item1, item2, item3 ]];
    self.contextSheet.delegate = self;
    UIGestureRecognizer *longpressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self
                                                                                           action: @selector(gestureHandler:)];
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                           action: @selector(gestureHandler:)];
    [self.languageContainerView addGestureRecognizer:longpressRecognizer];
    [self.languageContainerView addGestureRecognizer:tapRecognizer];
}

- (void)contextSheet:(VLDContextSheet *)contextSheet didSelectItem:(VLDContextSheetItem *)item {
    
    [[SSLanguageManager sharedInstance] setSelectedLanguage:item.languageCode];
    [self.currentLanguageImageView setImage:item.image];
}

- (void)gestureHandler:(UIGestureRecognizer *) gestureRecognizer {
   
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
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

- (void)setupLanguge {
  NSString *selectedLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:kSCLanguageKey] description];
    if ([selectedLanguage isEqualToString:kSCRussian]) {
        [self.currentLanguageImageView setImage:[UIImage imageNamed: @"ic_flag_russia"]];
    } else if ([selectedLanguage isEqualToString:kSCArmenian]) {
        [self.currentLanguageImageView setImage:[UIImage imageNamed: @"ic_flag_armenia"]];
    } else {
        [self.currentLanguageImageView setImage:[UIImage imageNamed: @"ic_flag_england"]];
    }
}

- (void)handleLanguageChange:(NSNotification *)notification {
    [self.startGameButton setTitle:[[SSLanguageManager sharedInstance] localizedString:@"start_game"] forState:UIControlStateNormal];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
