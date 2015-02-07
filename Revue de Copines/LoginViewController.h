//
//  LoginViewController.h
//  Revue de Copines
//
//  Created by Fábio Violante on 18/09/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UIButton *secondLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

- (IBAction)facebookButton:(id)sender;
- (IBAction)twitterButton:(id)sender;
- (IBAction)loginButton:(id)sender;

-(void) popBack;

@property (strong, nonatomic) HomeViewController *homeViewController;

@end
