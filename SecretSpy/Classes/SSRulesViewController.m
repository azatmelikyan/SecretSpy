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


@end
@implementation SSRulesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
   
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
    [self.headerView addSubview:self.coverImageView];
}

- (void)setupNavigation {
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    self.navigationView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.navigationView];
    self.navigationBar =  [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame), 44)];
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
    [self.backButton setImage:[UIImage imageNamed:@"ic_menu_back"] forState:UIControlStateNormal];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:[[SSLanguageManager sharedInstance] localizedString:@"rules_title"]];

    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    UIBarButtonItem* negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -16;
    
    navigationItem.leftBarButtonItems = @[negativeSeperator, leftBarItem];
    
    
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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
}

@end
