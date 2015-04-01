//
//  SubscriptionViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 13/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "WelcomeViewController.h"
#import "User.h"
#import "Localization.h"

@interface SubscriptionViewController ()

@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_landingFirstLabel setFont:[UIFont fontWithName:@"Apercu" size:20.0f]];
    [_landingSecondLabel setFont:[UIFont fontWithName:@"Apercu" size:20.0f]];
    [_landingThirdLabel setFont:[UIFont fontWithName:@"Apercu" size:24.0f]];
    [_landingFourthLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:16.0f]];
    
    User *user = [User getInstance];
    
    if (![user isLogedIn]) {
        [_landingThirdLabel setHidden:NO];
        [_landingFourthLabel setHidden:NO];
        [_logBtn setHidden:NO];
        [_arrowBtn setHidden:NO];
        [_loader stopAnimating];
        
        //NSLog(@"show welcome");
        //[self performSegueWithIdentifier:@"welcomeScreen" sender:nil];
    } else {
        [_landingThirdLabel setHidden:YES];
        [_landingFourthLabel setHidden:YES];
        [_logBtn setHidden:YES];
        [_arrowBtn setHidden:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CGRect viewFrame = self.view.frame;
    
    viewFrame.origin.y = -self.view.frame.size.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
}

- (IBAction)loginButton:(id)sender {
    [self performSegueWithIdentifier:@"goToLogin" sender:nil];
}

@end
