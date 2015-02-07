//
//  Subscription3ViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 14/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "Subscription3ViewController.h"
#import "HomeViewController.h"
#import "User.h"
#import "Localization.h"

@interface Subscription3ViewController ()

@end

@implementation Subscription3ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *registerItem = [[UIBarButtonItem alloc] initWithTitle:@"Enregistrer" style:UIBarButtonItemStylePlain target:self action:@selector(register)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Annuler" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    
    registerItem.tintColor = [UIColor whiteColor];
    [registerItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Apercu" size:16]} forState:UIControlStateNormal];
    backItem.tintColor = [UIColor whiteColor];
    [backItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Apercu" size:16]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = registerItem;
    self.navigationItem.leftBarButtonItem = backItem;
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    navTitle.text = @"S'inscrire";
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [navTitle setFont:[UIFont fontWithName:@"Apercu-Bold" size:20]];
    self.navigationItem.titleView = navTitle;
    
    [_firstLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:15.0f]];
    [_secondLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:15.0f]];
    [_thirdLabel setFont:[UIFont fontWithName:@"Apercu" size:16.0f]];
    [_thirdLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:15.0f]];
    [_nameInput setFont:[UIFont fontWithName:@"Apercu" size:16.0f]];
    [_emailInput setFont:[UIFont fontWithName:@"Apercu" size:16.0f]];
    [_passwordInput setFont:[UIFont fontWithName:@"Apercu" size:16.0f]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void) register {
    if (self.checkInternetConnection) {
        // TODO - Do Normal Registration
        
        User *user = [User getInstance];
        
        user.name = self.nameInput.text;
        user.email = self.emailInput.text;
        user.password = self.passwordInput.text;
        user.type = 1;
        
        if ([user validate]) {
            if ([user save]) {
                self.homeViewController = [[HomeViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
                
                [self.navigationController pushViewController:self.homeViewController animated:NO];
            }
        }
    }
}

- (IBAction)facebookButton:(id)sender {
    if (self.checkInternetConnection) {
        // TODO - Do Facebook Registration
        
        self.homeViewController = [[HomeViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        [self.navigationController pushViewController:self.homeViewController animated:NO];
    }
}

- (IBAction)twitterButton:(id)sender {
    if (self.checkInternetConnection) {
        // TODO - Do Twitter Registration
        
        self.homeViewController = [[HomeViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        [self.navigationController pushViewController:self.homeViewController animated:NO];
    }
}

- (IBAction)registerBlogger:(id)sender {
    if (self.checkInternetConnection) {
        User *user = [User getInstance];
        
        user.name = self.nameInput.text;
        user.email = self.emailInput.text;
        user.password = self.passwordInput.text;
        user.type = 2;
        
        //if ([user validate]) {
        //    if ([user validEmail])
                [self performSegueWithIdentifier:@"goToSub4" sender:nil];
        //}
    }
}

- (BOOL)checkInternetConnection {
    Localization *localization = [[Localization alloc] init];
    
    NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/checkConnection"] encoding:NSUTF8StringEncoding error:nil];
    
    if (![connect isEqualToString:@"success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"no internet connection" forLocale:@"fr"] message:[localization getStringForText:@"you must be connected to the internet" forLocale:@"fr"] delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
        
        [alert show];
        
        return FALSE;
    }
    
    return TRUE;
}

@end
