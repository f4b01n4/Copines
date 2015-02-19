//
//  Subscription2ViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 14/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "Subscription2ViewController.h"
#import "Subscription3ViewController.h"
#import "User.h"
#import "Localization.h"

@interface Subscription2ViewController ()

@end

@implementation Subscription2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_titleLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:16.0f]];
    [_conditionsLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:14.0f]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Annuler" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    
    backItem.tintColor = [UIColor whiteColor];
    [backItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Apercu" size:16]} forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = backItem;
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    navTitle.text = @"S'inscrire";
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [navTitle setFont:[UIFont fontWithName:@"Apercu-Bold" size:20]];
    self.navigationItem.titleView = navTitle;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) popBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)image1:(id)sender {
    _check1.hidden = !_check1.hidden;
}

- (IBAction)image2:(id)sender {
    _check2.hidden = !_check2.hidden;
}

- (IBAction)image3:(id)sender {
    _check3.hidden = !_check3.hidden;
}

- (IBAction)image4:(id)sender {
    _check4.hidden = !_check4.hidden;
}

- (IBAction)image5:(id)sender {
    _check5.hidden = !_check5.hidden;
}

- (IBAction)image6:(id)sender {
    _check6.hidden = !_check6.hidden;
}

- (IBAction)image7:(id)sender {
    _check7.hidden = !_check7.hidden;
}

- (IBAction)image8:(id)sender {
    _check8.hidden = !_check8.hidden;
}

- (IBAction)image9:(id)sender {
    _check9.hidden = !_check9.hidden;
}

- (IBAction)button:(id)sender {
    Localization *localization = [[Localization alloc] init];
    
    int total = 0;
    
    if (!_check1.hidden)
        total++;
    if (!_check2.hidden)
        total++;
    if (!_check3.hidden)
        total++;
    if (!_check4.hidden)
        total++;
    if (!_check5.hidden)
        total++;
    if (!_check6.hidden)
        total++;
    if (!_check7.hidden)
        total++;
    if (!_check8.hidden)
        total++;
    if (!_check9.hidden)
        total++;
    
    if (total < 1) {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"error" forLocale:@"fr"] message:[localization getStringForText:@"you need to select at least 1 category" forLocale:@"fr"] delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
        
        [error show];
        return;
    }
    
    User *user = [User getInstance];
    
    user.themes = [[NSMutableArray alloc] initWithObjects:
                    [NSNumber numberWithInt:[[NSNumber numberWithBool:!_check1.hidden] intValue] * 1],
                    [NSNumber numberWithInt:[[NSNumber numberWithBool:!_check2.hidden] intValue] * 2],
                    [NSNumber numberWithInt:[[NSNumber numberWithBool:!_check3.hidden] intValue] * 3],
                    [NSNumber numberWithInt:[[NSNumber numberWithBool:!_check4.hidden] intValue] * 4],
                    [NSNumber numberWithInt:[[NSNumber numberWithBool:!_check5.hidden] intValue] * 5],
                    [NSNumber numberWithInt:[[NSNumber numberWithBool:!_check6.hidden] intValue] * 6],
                    [NSNumber numberWithInt:[[NSNumber numberWithBool:!_check7.hidden] intValue] * 7],
                    [NSNumber numberWithInt:[[NSNumber numberWithBool:!_check8.hidden] intValue] * 8],
                    [NSNumber numberWithInt:[[NSNumber numberWithBool:!_check9.hidden] intValue] * 9],
                    nil];
    
    NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/checkConnection"] encoding:NSUTF8StringEncoding error:nil];
    
    if (![connect isEqualToString:@"success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"no internet connection" forLocale:@"fr"] message:[localization getStringForText:@"you must be connected to the internet" forLocale:@"fr"] delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
        
        [alert show];
    } else
        [self performSegueWithIdentifier:@"goToSub3" sender:nil];
}

@end
