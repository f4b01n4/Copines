//
//  WelcomeViewController.h
//  Copines
//
//  Created by Fábio Violante on 18/03/15.
//  Copyright (c) 2015 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController

@property (nonatomic) int currentSlide;
@property (strong, nonatomic) UIView *slide1;
@property (strong, nonatomic) UIView *slide2;
@property (strong, nonatomic) UIView *slide3;
@property (strong, nonatomic) UIButton *bullet1;
@property (strong, nonatomic) UIButton *bullet2;
@property (strong, nonatomic) UIButton *bullet3;

@end