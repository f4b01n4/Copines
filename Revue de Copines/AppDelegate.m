//
//  AppDelegate.m
//  Revue de Copines
//
//  Created by Fábio Violante on 13/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SubscriptionViewController.h"
#import "HomeViewController.h"
#import "User.h"
#import "Localization.h"

@implementation AppDelegate

- (void)checkInternetConnection {
    Localization *localization = [[Localization alloc] init];
    
    NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://ec2-54-170-94-162.eu-west-1.compute.amazonaws.com/ios/checkConnection"] encoding:NSUTF8StringEncoding error:nil];
    
    if (![connect isEqualToString:@"success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"no internet connection" forLocale:@"fr"] message:[localization getStringForText:@"you must be connected to the internet" forLocale:@"fr"] delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
        
        [alert show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    CGPoint location = [[[event allTouches] anyObject] locationInView:[self window]];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if (CGRectContainsPoint(statusBarFrame, location))
        [self statusBarTouchedAction];
}

- (void)statusBarTouchedAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:kStatusBarTappedNotification
                                                        object:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self checkInternetConnection];
    
    User *user = [User getInstance];
    if (![user isLogedIn]) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TermsAccepted"] != YES) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TermsAccepted"];
            self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
        } else
          self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"NormalInitialViewController"];  
        
        
        //self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"NormalInitialViewController"];
        //self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    } else {
        UINavigationController* navController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"BaseNavigationController2"];
        
        self.window.rootViewController = navController;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
