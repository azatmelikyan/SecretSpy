//
//  SSRulesViewController.m
//  SecretSpy
//
//  Created by Christ on 11/13/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "SSRulesViewController.h"
#import "SSLanguageManager.h"
#import "SCWrapperScrollView.h"
#import "SCParalaxBehavior.h"
#import "UIImage+ImageEffects.h"

@interface SSRulesViewController () <UIScrollViewDelegate>

@property (nonatomic) UIImageView *coverImageView;
@property (nonatomic) SCWrapperScrollView *scrollViewWrapper;
@property (nonatomic) SCParalaxBehavior *paralaxBehavior;
@property (nonatomic) UINavigationBar *navigationBar;
@property (nonatomic) UIView *navigationView;
@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIImage *navigationBarShadowImage;
@property (nonatomic) UITextView *rulesTextView;
@property (nonatomic) UIView *headerView;
@property (nonatomic) UIStatusBarStyle statusBarStyle;


@end
@implementation SSRulesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
   
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}



#pragma mark - setup

- (BOOL)hidesNavigationBarWhenPushed {
    return YES;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupHeaderNode];
    [self setupCollectionNode];
    [self setupScrollViewWrapper];
    [self setupNavigation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setStatusBarStyle:self.scrollViewWrapper.contentOffset.y >= CGRectGetHeight(self.headerView.frame) - 64.f ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat top = 20.f;
   // if (DeviceSystemMajorVersion() >= 11) {
      //  top = self.view.sc_safeAreaInsets.top;
    //}
    if ([scrollView isKindOfClass:[SCWrapperScrollView class]]) {
        
        CGFloat y1 = CGRectGetHeight(self.headerView.frame) - 2*44 - top;
        CGFloat y2 = CGRectGetHeight(self.headerView.frame) - 44 - top;
        CGFloat y3 = CGRectGetHeight(self.headerView.frame) - top;
        CGFloat y = scrollView.contentOffset.y;
        
        if ((y >= y1) && (y <= y2)) {
            CGFloat alpha = (y2 - y)/(y2 - y1);
            [self setupNavigationForFirstStateWithAlpha:alpha];
        } else if ((y >= y2) && (y < y3)) {
            CGFloat alpha = (y - y2) /(y3 -y2);
            CGFloat fontSize = 5*(y3 - y)/(y3 - y2) + 17.f;
            [self setupNavigationForSecondStateWithAlpha:alpha fontSize:fontSize];
        } else if (y < y1) {
            [self setupNavigationForThirdState];
        } else if (y >= y3) {
            [self setupNavigationForFourthState];
        }
    } else if ([scrollView isKindOfClass:[UICollectionView class]] && scrollView.contentOffset.y == 0) {
        [self setupNavigationForFourthState];
    }
}



#pragma mark - Navigation Bar Animation

- (void)setupNavigationForFirstStateWithAlpha:(CGFloat)alpha {
    [self setStatusBarStyle:UIStatusBarStyleLightContent];
    UIWindow *statusBarWindow = (UIWindow *)[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    statusBarWindow.alpha = alpha;
   self.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f],
                                               NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:alpha]};
    self.navigationBar.shadowImage = self.navigationBarShadowImage;
    [self.backButton setImage:[[UIImage imageNamed:@"ic_back"] imageWithTintColor:[[UIColor whiteColor]colorWithAlphaComponent:alpha]] forState:UIControlStateNormal];

}

- (void)setupNavigationForSecondStateWithAlpha:(CGFloat)alpha fontSize:(CGFloat)fontSize {
    [self setStatusBarStyle:UIStatusBarStyleDefault];
    UIWindow *statusBarWindow = (UIWindow *)[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    statusBarWindow.alpha = alpha;
    
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f],
                                               NSForegroundColorAttributeName : [[UIColor darkGrayColor] colorWithAlphaComponent:alpha]};
    self.navigationBar.shadowImage = self.navigationBarShadowImage;
    
    [self.backButton setImage:[[UIImage imageNamed:@"ic_back"] imageWithTintColor:[[UIColor grayColor]colorWithAlphaComponent:alpha]] forState:UIControlStateNormal];
   self.navigationView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
   
}

- (void)setupNavigationForThirdState {
    [self setStatusBarStyle:UIStatusBarStyleLightContent];
    UIWindow *statusBarWindow = (UIWindow *)[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    statusBarWindow.alpha = 1;
    self.navigationView.backgroundColor = [UIColor clearColor];
    self.navigationBar.shadowImage = self.navigationBarShadowImage;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f],
                                               NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.backButton setImage:[[UIImage imageNamed:@"ic_back"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
}

- (void)setupNavigationForFourthState {
    [self setStatusBarStyle:UIStatusBarStyleDefault];
    UIWindow *statusBarWindow = (UIWindow *)[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    statusBarWindow.alpha = 1;
   
    self.navigationBar.shadowImage =  [UIImage imageWithColor:[UIColor colorWithRed:0xF0 green:0xF0 blue:0xF0 alpha:1] size:CGSizeMake(1, 1)];;
    self.navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f],
                                               NSForegroundColorAttributeName : [UIColor darkGrayColor]};
    
    [self.backButton setImage:[[UIImage imageNamed:@"ic_back"] imageWithTintColor:[UIColor grayColor]] forState:UIControlStateNormal];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}


- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}


- (void)setupScrollViewWrapper {
    CGRect scrollWrappeFrame = self.view.bounds;
    CGFloat offset =  0.f;
   // offset += sc_isIPhoneX() ? 34 : 0;
    scrollWrappeFrame.size.height = CGRectGetHeight(self.view.frame) - offset;
    SCWrapperScrollView *scrollViewWrapper = [[SCWrapperScrollView alloc] initWithFrame:scrollWrappeFrame];
//    if (DeviceSystemMajorVersion() >= 11) {
//        scrollViewWrapper.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
    scrollViewWrapper.showsVerticalScrollIndicator = NO;
    self.scrollViewWrapper = scrollViewWrapper;
    self.scrollViewWrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.scrollViewWrapper atIndex:0];
    self.scrollViewWrapper.delegate = self;
    self.scrollViewWrapper.scrollContainerInsets = UIEdgeInsetsMake(CGRectGetHeight(self.headerView.frame), 0, 0, 0);
    self.paralaxBehavior = [[SCParalaxBehavior alloc] initWithTargetView:self.headerView];
    self.paralaxBehavior.scrollView = self.scrollViewWrapper;
    [self.scrollViewWrapper addSubview:self.headerView];
    self.scrollViewWrapper.scrollContainerView = self.rulesTextView;
    self.scrollViewWrapper.scrollView = self.rulesTextView;
    [self.scrollViewWrapper sendSubviewToBack:self.headerView];
    [self.scrollViewWrapper updateContentSize];
}

- (void)setupHeaderNode {
    CGSize headerSize = CGSizeMake(CGRectGetWidth(self.view.frame),MAX(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) * 0.385f);
    CGRect headerFrame = CGRectZero;
    headerFrame.size = headerSize;
    self.headerView = [[UIView alloc] initWithFrame:headerFrame];
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.coverImageView = [[UIImageView alloc] initWithFrame:self.headerView.frame];
    self.coverImageView.image = [UIImage imageNamed:@"info_top_page"];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headerView addSubview:self.coverImageView];
}

- (void)setupNavigation {
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    self.navigationView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.navigationView];
    self.navigationBar =  [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20 ,CGRectGetWidth(self.view.frame), 44)];
    self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                               NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBar.translucent = YES;
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBarShadowImage = [[UIImage alloc] init];
    self.navigationBar.shadowImage = self.navigationBarShadowImage;
    self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.navigationView addSubview:self.navigationBar];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:[[SSLanguageManager sharedInstance] localizedString:@"rules_title"]];

    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    negativeSpacer.width = -16;
     navigationItem.leftBarButtonItems = @[leftBarItem,negativeSpacer];
   self.navigationBar.items = @[navigationItem];
}

- (void)setupCollectionNode {
    CGFloat offset =  0.f;
    //  offset += sc_isIPhoneX() ? 34 : 0;
    self.rulesTextView = [[UITextView alloc] initWithFrame: CGRectMake(0, CGRectGetMaxY(self.headerView.frame),
                                                                       CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - offset)];
    self.rulesTextView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIFont *font = [UIFont systemFontOfSize:14.f];
    [self.rulesTextView setFont:font];
    self.rulesTextView.text = [[SSLanguageManager sharedInstance] localizedString:@"rules_text"];
    self.rulesTextView.editable = NO;
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
