//
//  SubscriptionViewController.h
//  Revue de Copines
//
//  Created by Fábio Violante on 13/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscriptionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *landingFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *landingSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *landingThirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *landingFourthLabel;
@property (weak, nonatomic) IBOutlet UIButton *logBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrowBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

- (IBAction)loginButton:(id)sender;

@end
