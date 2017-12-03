//
//  SSTimerViewController.m
//  SecretSpy
//
//  Created by Christ on 11/16/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "SSTimerViewController.h"
#import "ViewController.h"
@import GoogleMobileAds;

@interface SSTimerViewController () <GADBannerViewDelegate, GADInterstitialDelegate>

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSUInteger remainingCounts;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic) NSString *resultString;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *startAndResultButton;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeightConstraint;

@property (nonatomic) GADBannerView *adBannerView;
@property (nonatomic) GADInterstitial *adFullBannerView;

@end

@implementation SSTimerViewController

- (instancetype)initWithTimeInterval:(NSUInteger)timeInterval resultString:(NSString *)resultString {
    self = [self init];
    if (self) {
        self.remainingCounts = timeInterval;
        self.resultString = resultString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timerLabelHeightConstraint.constant = 0;
    [self setupAds];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)setupAds {
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID,                       // All simulators
                             @"9f65636828e14ea35a25f2a516c3c81b" ]; // Sample device ID
    [self.adBannerView loadRequest:request];
    GADRequest *requestForFll = [GADRequest request];
    requestForFll.testDevices = @[ kGADSimulatorID,                       // All simulators
                                   @"9f65636828e14ea35a25f2a516c3c81b" ]; // Sample device ID
    self.adFullBannerView = [self createAndLoadInterstitial];
    [self.adFullBannerView loadRequest:requestForFll];
}

- (GADBannerView *)adBannerView {
    if (!_adBannerView) {
        _adBannerView = [[GADBannerView alloc] init];
        [_adBannerView setAdSize:kGADAdSizeSmartBannerLandscape];
        _adBannerView.adUnitID = @"ca-app-pub-8490603098673718/2921064708";
        _adBannerView.delegate = self;
        _adBannerView.rootViewController = self;
    }
    return _adBannerView;
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-8490603098673718/4778492739"];
    interstitial.delegate = self;
    return interstitial;
}

- (void)presentFullScreenAd {
    if (self.adFullBannerView.isReady) {
        [self.adFullBannerView presentFromRootViewController:self];
    }
    GADRequest *requestForFll = [GADRequest request];
    requestForFll.testDevices = @[ kGADSimulatorID,                       // All simulators
                                   @"9f65636828e14ea35a25f2a516c3c81b" ]; // Sample device ID
    [self.adFullBannerView loadRequest:requestForFll];
}

- (IBAction)startTimer:(id)sender {
    if (self.timer) {
        [self showResult];
        return;
    }
    self.timerLabelHeightConstraint.constant = 70;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(countDown)
                                                userInfo:nil
                                                 repeats:YES];
    [self countDown];
    [self.startAndResultButton setTitle:@"Result" forState:UIControlStateNormal];
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
    if (self.timer) {
        [self.timer invalidate];
    }
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       if (self.timer) {
                                           self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                                         target:self
                                                                                       selector:@selector(countDown)
                                                                                       userInfo:nil
                                                                                        repeats:YES];
                                       }
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   if (self.adFullBannerView.isReady) {
                                       [self presentFullScreenAd];
                                   } else {
                                       [self goBack];
                                   }

                               }];
    [self showPopUpWithActions:@[cancelAction, okAction] title:@"Close the game" message:@"Are you sure you want close the game?"];
}

- (void)showPopUpWithActions:(NSArray <UIAlertAction *> *)actions title:(NSString *)title message:(NSString *)message{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertController addAction:obj];
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showResult {
    if (self.timer) {
        [self.timer invalidate];
    }
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       if (self.timer) {
                                           self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                                         target:self
                                                                                       selector:@selector(countDown)
                                                                                       userInfo:nil
                                                                                        repeats:YES];
                                       }
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   self.timerLabel.text = self.resultString;
                                   self.startAndResultButton.hidden = YES;
                               }];
    [self showPopUpWithActions:@[cancelAction, okAction] title:@"Show Spy index" message:@"Are You sure you discovered the spy?"];
}

- (void)goBack {
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ViewController class]]) {
            [self.navigationController popToViewController:obj animated:YES];
        }
    }];
}

#pragma mark - GADBannerViewDelegate


- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    self.bannerViewHeightConstraint.constant = 44;
    bannerView.frame = CGRectMake(0, 0, self.bannerView.frame.size.width, 44);
    [self.bannerView addSubview:bannerView];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"error %@", error.description);
}

#pragma mark - GADBannerViewDelegate

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    [self goBack];
}

@end
