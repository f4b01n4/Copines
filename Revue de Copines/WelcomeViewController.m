//
//  WelcomeViewController.m
//  Copines
//
//  Created by Fábio Violante on 18/03/15.
//  Copyright (c) 2015 Pears & Bragston. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    float statusHeight = (40 / 2) * screenRect.size.width / 320;
    float yPos = (41 / 2) * screenRect.size.width / 320;
    float imgWidth = (533 / 2) * screenRect.size.width / 320;
    float imgHeight = (770 / 2) * screenRect.size.width / 320;
    float spacer = (29 / 2) * screenRect.size.width / 320;
    float x1Pos = (57 / 2) * screenRect.size.width / 320;
    float x2Pos = x1Pos + imgWidth + spacer;
    float x3Pos = x2Pos + imgWidth + spacer;
    float bulletsViewHeight = (130 / 2) * screenRect.size.width / 320;
    float bulletSize = (25 / 2) * screenRect.size.width / 320;
    float bulletsY = (45 / 2) * screenRect.size.width / 320;
    float bulletsSpace = (21 / 2) * screenRect.size.width / 320;
    float bullet1X = (261 / 2) * screenRect.size.width / 320;
    float bullet2X = bullet1X + bulletSize + bulletsSpace;
    float bullet3X = bullet2X + bulletSize + bulletsSpace;
    float bottomViewHeight = screenRect.size.height - (statusHeight + yPos + imgHeight + bulletsViewHeight);
    float bottomViewY = screenRect.size.height - bottomViewHeight;
    float bottomButtonsWidth = (296 / 2) * screenRect.size.width / 320;
    float bottomButtonsHeight = (86 / 2) * screenRect.size.width / 320;
    float bottomButtonsSpace = (17 / 2) * screenRect.size.width / 320;
    float bottomButton1X = (16 / 2) * screenRect.size.width / 320;
    float bottomButton2X = bottomButton1X + bottomButtonsWidth + bottomButtonsSpace;
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgWidth, imgHeight)];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgWidth, imgHeight)];
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgWidth, imgHeight)];
    
    [imageView1 setImage:[UIImage imageNamed:@"welcome-image-1.png"]];
    [imageView2 setImage:[UIImage imageNamed:@"welcome-image-2.png"]];
    [imageView3 setImage:[UIImage imageNamed:@"welcome-image-3.png"]];
    
    self.slide1 = [[UIView alloc] initWithFrame:CGRectMake(x1Pos, yPos, imgWidth, imgHeight)];
    self.slide2 = [[UIView alloc] initWithFrame:CGRectMake(x2Pos, yPos, imgWidth, imgHeight)];
    self.slide3 = [[UIView alloc] initWithFrame:CGRectMake(x3Pos, yPos, imgWidth, imgHeight)];
    [self.slide1 addSubview:imageView1];
    [self.slide2 addSubview:imageView2];
    [self.slide3 addSubview:imageView3];
    
    UIView *slideView = [[UIView alloc] initWithFrame:CGRectMake(0, statusHeight, screenRect.size.width, imgHeight + yPos)];
    [slideView setBackgroundColor:[UIColor whiteColor]];
    [slideView addSubview:self.slide1];
    [slideView addSubview:self.slide2];
    [slideView addSubview:self.slide3];
    
    UISwipeGestureRecognizer *gestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sliderSwipeLeft)];
    UISwipeGestureRecognizer *gestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sliderSwipeRight)];
    [gestureRecognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [gestureRecognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [slideView addGestureRecognizer:gestureRecognizerLeft];
    [slideView addGestureRecognizer:gestureRecognizerRight];
    
    self.bullet1 = [[UIButton alloc] initWithFrame:CGRectMake(bullet1X, bulletsY, bulletSize, bulletSize)];
    self.bullet2 = [[UIButton alloc] initWithFrame:CGRectMake(bullet2X, bulletsY, bulletSize, bulletSize)];
    self.bullet3 = [[UIButton alloc] initWithFrame:CGRectMake(bullet3X, bulletsY, bulletSize, bulletSize)];
    
    [self.bullet1 setImage:[UIImage imageNamed:@"welcome-dot-grey.png"] forState:UIControlStateNormal];
    [self.bullet1 setImage:[UIImage imageNamed:@"welcome-dot-red.png"] forState:UIControlStateSelected];
    [self.bullet1 addTarget:self action:@selector(clickBulletOne) forControlEvents:UIControlEventTouchUpInside];
    [self.bullet2 setImage:[UIImage imageNamed:@"welcome-dot-grey.png"] forState:UIControlStateNormal];
    [self.bullet2 setImage:[UIImage imageNamed:@"welcome-dot-red.png"] forState:UIControlStateSelected];
    [self.bullet2 addTarget:self action:@selector(clickBulletTwo) forControlEvents:UIControlEventTouchUpInside];
    [self.bullet3 setImage:[UIImage imageNamed:@"welcome-dot-grey.png"] forState:UIControlStateNormal];
    [self.bullet3 setImage:[UIImage imageNamed:@"welcome-dot-red.png"] forState:UIControlStateSelected];
    [self.bullet3 addTarget:self action:@selector(clickBulletThree) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bulletsView = [[UIView alloc] initWithFrame:CGRectMake(0, statusHeight + yPos + imgHeight, screenRect.size.width, bulletsViewHeight)];
    [bulletsView setBackgroundColor:[UIColor whiteColor]];
    [bulletsView addSubview:self.bullet1];
    [bulletsView addSubview:self.bullet2];
    [bulletsView addSubview:self.bullet3];
    
    [self.bullet1 setSelected:YES];
    
    UIButton *bottomButton1 = [[UIButton alloc] initWithFrame:CGRectMake(bottomButton1X, 10, bottomButtonsWidth, bottomButtonsHeight)];
    UIButton *bottomButton2 = [[UIButton alloc] initWithFrame:CGRectMake(bottomButton2X, 10, bottomButtonsWidth, bottomButtonsHeight)];
    
    [bottomButton1 setImage:[UIImage imageNamed:@"welcome-btn-1.png"] forState:UIControlStateNormal];
    [bottomButton1 addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomButton2 setImage:[UIImage imageNamed:@"welcome-btn-2.png"] forState:UIControlStateNormal];
    [bottomButton2 addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomViewY, screenRect.size.width, bottomViewY)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [bottomView addSubview:bottomButton1];
    [bottomView addSubview:bottomButton2];
    
    [self.view addSubview:slideView];
    [self.view addSubview:bulletsView];
    [self.view addSubview:bottomView];
}

- (void)sliderSwipeRight {
    if (self.currentSlide > 0) {
        CGRect viewFrame1 = self.slide1.frame;
        CGRect viewFrame2 = self.slide2.frame;
        CGRect viewFrame3 = self.slide3.frame;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        float xAmount = (563 / 2) * screenRect.size.width / 320;
        
        viewFrame1.origin.x += xAmount;
        viewFrame2.origin.x += xAmount;
        viewFrame3.origin.x += xAmount;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.slide1.frame = viewFrame1;
        self.slide2.frame = viewFrame2;
        self.slide3.frame = viewFrame3;
        
        [UIView commitAnimations];
        
        self.currentSlide--;
        
        [self setBulletSelected:self.currentSlide + 1];
    }
}

- (void)sliderSwipeLeft {
    if (self.currentSlide < 2) {
        CGRect viewFrame1 = self.slide1.frame;
        CGRect viewFrame2 = self.slide2.frame;
        CGRect viewFrame3 = self.slide3.frame;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        float xAmount = (563 / 2) * screenRect.size.width / 320;
        
        viewFrame1.origin.x -= xAmount;
        viewFrame2.origin.x -= xAmount;
        viewFrame3.origin.x -= xAmount;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.slide1.frame = viewFrame1;
        self.slide2.frame = viewFrame2;
        self.slide3.frame = viewFrame3;
        
        [UIView commitAnimations];
        
        self.currentSlide++;
        
        [self setBulletSelected:self.currentSlide + 1];
    }
}

- (void)setBulletSelected:(int)bullet {
    switch (bullet) {
        case 1:
            [self.bullet1 setSelected:YES];
            [self.bullet2 setSelected:NO];
            [self.bullet3 setSelected:NO];
            break;
        case 2:
            [self.bullet1 setSelected:NO];
            [self.bullet2 setSelected:YES];
            [self.bullet3 setSelected:NO];
            break;
        case 3:
            [self.bullet1 setSelected:NO];
            [self.bullet2 setSelected:NO];
            [self.bullet3 setSelected:YES];
            break;
    }
}

- (void)clickBulletOne {
    if ((self.currentSlide + 1) != 1) {
        CGRect viewFrame1 = self.slide1.frame;
        CGRect viewFrame2 = self.slide2.frame;
        CGRect viewFrame3 = self.slide3.frame;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        float xAmount = (563 / 2) * screenRect.size.width / 320;
        
        if ((self.currentSlide + 1) == 3)
            xAmount *= 2;
        
        viewFrame1.origin.x += xAmount;
        viewFrame2.origin.x += xAmount;
        viewFrame3.origin.x += xAmount;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.slide1.frame = viewFrame1;
        self.slide2.frame = viewFrame2;
        self.slide3.frame = viewFrame3;
        
        [UIView commitAnimations];
        
        if ((self.currentSlide + 1) == 3)
            self.currentSlide -= 2;
        else
            self.currentSlide--;
        
        [self setBulletSelected:self.currentSlide + 1];
    }
}

- (void)clickBulletTwo {
    if ((self.currentSlide + 1) != 2) {
        CGRect viewFrame1 = self.slide1.frame;
        CGRect viewFrame2 = self.slide2.frame;
        CGRect viewFrame3 = self.slide3.frame;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        float xAmount = (563 / 2) * screenRect.size.width / 320;
        
        if ((self.currentSlide + 1) == 1) {
            viewFrame1.origin.x -= xAmount;
            viewFrame2.origin.x -= xAmount;
            viewFrame3.origin.x -= xAmount;
        } else {
            viewFrame1.origin.x += xAmount;
            viewFrame2.origin.x += xAmount;
            viewFrame3.origin.x += xAmount;
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.slide1.frame = viewFrame1;
        self.slide2.frame = viewFrame2;
        self.slide3.frame = viewFrame3;
        
        [UIView commitAnimations];
        
        if ((self.currentSlide + 1) == 1)
            self.currentSlide++;
        else
            self.currentSlide--;
        
        [self setBulletSelected:self.currentSlide + 1];
    }
}

- (void)clickBulletThree {
    if ((self.currentSlide + 1) != 3) {
        CGRect viewFrame1 = self.slide1.frame;
        CGRect viewFrame2 = self.slide2.frame;
        CGRect viewFrame3 = self.slide3.frame;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        float xAmount = (563 / 2) * screenRect.size.width / 320;
        
        if ((self.currentSlide + 1) == 1)
            xAmount *= 2;
        
        viewFrame1.origin.x -= xAmount;
        viewFrame2.origin.x -= xAmount;
        viewFrame3.origin.x -= xAmount;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.slide1.frame = viewFrame1;
        self.slide2.frame = viewFrame2;
        self.slide3.frame = viewFrame3;
        
        [UIView commitAnimations];
        
        if ((self.currentSlide + 1) == 1)
            self.currentSlide += 2;
        else
            self.currentSlide++;
        
        [self setBulletSelected:self.currentSlide + 1];
    }
}

- (void)registerAction {
    [self performSegueWithIdentifier:@"goToRegister2" sender:nil];
}

- (void)loginAction {
    [self performSegueWithIdentifier:@"goToLogin2" sender:nil];
}

@end
