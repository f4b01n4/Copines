//
//  AppDelegate.h
//  Revue de Copines
//
//  Created by Fábio Violante on 13/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;

static NSString * const kStatusBarTappedNotification = @"statusBarTappedNotification";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HomeViewController *homeViewController;

-(void) checkInternetConnection;

@end