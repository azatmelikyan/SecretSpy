//
//  SSRulesViewController.m
//  SecretSpy
//
//  Created by Christ on 11/13/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "SSRulesViewController.h"
#import "SSLanguageManager.h"

@interface SSRulesViewController ()
@property (weak, nonatomic) IBOutlet UITextView *rulesText;

@end

@implementation SSRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.rulesText.text = [[SSLanguageManager sharedInstance] localizedString:@"rules_text"];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backBtnCliked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
