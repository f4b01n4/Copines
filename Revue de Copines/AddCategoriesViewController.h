//
//  AddCategoriesViewController.h
//  Revue de Copines
//
//  Created by Fábio Violante on 18/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCategoriesViewController : UIViewController

@property (strong, nonatomic) HomeViewController *hvc;
@property (strong, nonatomic) UIView *slider;
@property (strong, nonatomic) UILabel *catTitle;
@property (strong, nonatomic) UIButton *slide1Btn;
@property (strong, nonatomic) UIButton *slide2Btn;
@property (strong, nonatomic) UIButton *slide3Btn;
@property (strong, nonatomic) UIButton *slide4Btn;
@property (strong, nonatomic) UIButton *slide5Btn;
@property (strong, nonatomic) UIButton *slide6Btn;
@property (strong, nonatomic) UIButton *slide7Btn;
@property (strong, nonatomic) UIButton *slide8Btn;
@property (strong, nonatomic) UIButton *slide9Btn;
@property (nonatomic) int currentSlide;
@property (nonatomic) int nSelected;

-(void)setHomeViewController:(HomeViewController*)hvc;

@end