//
//  AddCategoriesViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 18/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "User.h"
#import "HomeViewController.h"
#import "AddCategoriesViewController.h"
#import "Localization.h"

@interface AddCategoriesViewController ()

@end

@implementation AddCategoriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hide Back Button
    self.navigationItem.hidesBackButton = YES;
    
    // Set Right Bar Button Item
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Terminé" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    backItem.tintColor = [UIColor whiteColor];
    [backItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Apercu" size:16]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = backItem;
    
    // Set Title
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    navTitle.text = @"Ajouter des catégories";
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [navTitle setFont:[UIFont fontWithName:@"Apercu-Bold" size:20]];
    self.navigationItem.titleView = navTitle;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    UIImageView *backgroundImg = [[UIImageView alloc] initWithImage:backgroundImage];
    backgroundImg.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:backgroundImg];
    
    [self initSlider];
    
    User *user = [User getInstance];
    
    self.nSelected = 0;
    
    [self setCategorySelected:[user.themes[0] intValue]];
    [self setCategorySelected:[user.themes[1] intValue]];
    [self setCategorySelected:[user.themes[2] intValue]];
    [self setCategorySelected:[user.themes[3] intValue]];
    [self setCategorySelected:[user.themes[4] intValue]];
    [self setCategorySelected:[user.themes[5] intValue]];
    [self setCategorySelected:[user.themes[6] intValue]];
    [self setCategorySelected:[user.themes[7] intValue]];
    [self setCategorySelected:[user.themes[8] intValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setHomeViewController:(id)hvc {
    self.hvc = hvc;
}

-(void) popBack {
    Localization *localization = [[Localization alloc] init];
    
    if (self.nSelected < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"error" forLocale:@"fr"] message:@"" delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
        alert.message = [localization getStringForText:@"you need to select at least 1 category" forLocale:@"fr"];
        [alert show];
    } else {
        User *user = [User getInstance];
        
        user.themes = [[NSMutableArray alloc] initWithObjects:
                       [NSNumber numberWithInt:[[NSNumber numberWithBool:self.slide1Btn.selected] intValue] * 1],
                       [NSNumber numberWithInt:[[NSNumber numberWithBool:self.slide2Btn.selected] intValue] * 2],
                       [NSNumber numberWithInt:[[NSNumber numberWithBool:self.slide3Btn.selected] intValue] * 3],
                       [NSNumber numberWithInt:[[NSNumber numberWithBool:self.slide5Btn.selected] intValue] * 4],
                       [NSNumber numberWithInt:[[NSNumber numberWithBool:self.slide7Btn.selected] intValue] * 5],
                       [NSNumber numberWithInt:[[NSNumber numberWithBool:self.slide6Btn.selected] intValue] * 6],
                       [NSNumber numberWithInt:[[NSNumber numberWithBool:self.slide4Btn.selected] intValue] * 7],
                       [NSNumber numberWithInt:[[NSNumber numberWithBool:self.slide9Btn.selected] intValue] * 8],
                       [NSNumber numberWithInt:[[NSNumber numberWithBool:self.slide8Btn.selected] intValue] * 9],
                       nil];
        
        [user update];
        
        CGRect viewFrame = self.slider.frame;
        viewFrame.origin.x = 0;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.slider.frame = viewFrame;
        
        [UIView commitAnimations];
        
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController popViewControllerAnimated:YES];
        
        [self.hvc reinitCategoriesLoading];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:1];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hvc reinitCategories];
            });
        });
    }
}

- (void)initSlider {
    UIImage *slide1 = [UIImage imageNamed:@"1_Mode.png"];
    UIImage *slide2 = [UIImage imageNamed:@"2_Beauté.png"];
    UIImage *slide3 = [UIImage imageNamed:@"3_Diy.png"];
    UIImage *slide4 = [UIImage imageNamed:@"4_Food.png"];
    UIImage *slide5 = [UIImage imageNamed:@"5_Voyages.png"];
    UIImage *slide6 = [UIImage imageNamed:@"6_Fitness.png"];
    UIImage *slide7 = [UIImage imageNamed:@"7_Décoration.png"];
    UIImage *slide8 = [UIImage imageNamed:@"8_Famille.png"];
    UIImage *slide9 = [UIImage imageNamed:@"9_Mariage.png"];
    UIImage *plusImg = [UIImage imageNamed:@"add-categories.png"];
    UIImage *checkedImg = [UIImage imageNamed:@"check-categories.png"];
    UIImage *overlayImg = [UIImage imageNamed:@"categories_overlay.png"];
    
    UIImageView *slide1ImgView = [[UIImageView alloc] initWithImage:slide1];
    UIImageView *slide2ImgView = [[UIImageView alloc] initWithImage:slide2];
    UIImageView *slide3ImgView = [[UIImageView alloc] initWithImage:slide3];
    UIImageView *slide4ImgView = [[UIImageView alloc] initWithImage:slide4];
    UIImageView *slide5ImgView = [[UIImageView alloc] initWithImage:slide5];
    UIImageView *slide6ImgView = [[UIImageView alloc] initWithImage:slide6];
    UIImageView *slide7ImgView = [[UIImageView alloc] initWithImage:slide7];
    UIImageView *slide8ImgView = [[UIImageView alloc] initWithImage:slide8];
    UIImageView *slide9ImgView = [[UIImageView alloc] initWithImage:slide9];
    
    UIImageView *overlay1ImgView = [[UIImageView alloc] initWithImage:overlayImg];
    UIImageView *overlay2ImgView = [[UIImageView alloc] initWithImage:overlayImg];
    UIImageView *overlay3ImgView = [[UIImageView alloc] initWithImage:overlayImg];
    UIImageView *overlay4ImgView = [[UIImageView alloc] initWithImage:overlayImg];
    UIImageView *overlay5ImgView = [[UIImageView alloc] initWithImage:overlayImg];
    UIImageView *overlay6ImgView = [[UIImageView alloc] initWithImage:overlayImg];
    UIImageView *overlay7ImgView = [[UIImageView alloc] initWithImage:overlayImg];
    UIImageView *overlay8ImgView = [[UIImageView alloc] initWithImage:overlayImg];
    UIImageView *overlay9ImgView = [[UIImageView alloc] initWithImage:overlayImg];
    
    self.slide1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.slide2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.slide3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.slide4Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.slide5Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.slide6Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.slide7Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.slide8Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.slide9Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.slide1Btn setImage:plusImg forState:UIControlStateNormal];
    [self.slide1Btn setImage:checkedImg forState:UIControlStateSelected];
    [self.slide2Btn setImage:plusImg forState:UIControlStateNormal];
    [self.slide2Btn setImage:checkedImg forState:UIControlStateSelected];
    [self.slide3Btn setImage:plusImg forState:UIControlStateNormal];
    [self.slide3Btn setImage:checkedImg forState:UIControlStateSelected];
    [self.slide4Btn setImage:plusImg forState:UIControlStateNormal];
    [self.slide4Btn setImage:checkedImg forState:UIControlStateSelected];
    [self.slide5Btn setImage:plusImg forState:UIControlStateNormal];
    [self.slide5Btn setImage:checkedImg forState:UIControlStateSelected];
    [self.slide6Btn setImage:plusImg forState:UIControlStateNormal];
    [self.slide6Btn setImage:checkedImg forState:UIControlStateSelected];
    [self.slide7Btn setImage:plusImg forState:UIControlStateNormal];
    [self.slide7Btn setImage:checkedImg forState:UIControlStateSelected];
    [self.slide8Btn setImage:plusImg forState:UIControlStateNormal];
    [self.slide8Btn setImage:checkedImg forState:UIControlStateSelected];
    [self.slide9Btn setImage:plusImg forState:UIControlStateNormal];
    [self.slide9Btn setImage:checkedImg forState:UIControlStateSelected];
    
    int size = (self.view.frame.size.width * 50) / 320;
    int posX = (self.view.frame.size.width * 79) / 320;
    int posY = (((self.view.frame.size.height * ((self.view.frame.size.width * 208) / 320)) / 370) / 2) - size / 2;
    
    if (self.view.frame.size.width == 320)
        posY = (((self.view.frame.size.height * 208) / 320) / 2) - size / 2;
    
    self.slide1Btn.frame = CGRectMake(posX, posY, size, size);
    self.slide1Btn.tag = 10;
    self.slide2Btn.frame = CGRectMake(posX, posY, size, size);
    self.slide3Btn.frame = CGRectMake(posX, posY, size, size);
    self.slide4Btn.frame = CGRectMake(posX, posY, size, size);
    self.slide5Btn.frame = CGRectMake(posX, posY, size, size);
    self.slide6Btn.frame = CGRectMake(posX, posY, size, size);
    self.slide7Btn.frame = CGRectMake(posX, posY, size, size);
    self.slide8Btn.frame = CGRectMake(posX, posY, size, size);
    self.slide9Btn.frame = CGRectMake(posX, posY, size, size);
    
    [self.slide1Btn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
    [self.slide2Btn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
    [self.slide3Btn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
    [self.slide4Btn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
    [self.slide5Btn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
    [self.slide6Btn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
    [self.slide7Btn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
    [self.slide8Btn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
    [self.slide9Btn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    int imgWidth = (self.view.frame.size.width * 208) / 320;
    int imgHeight = (self.view.frame.size.height * imgWidth) / 370;
    int imgWidth2 = (self.view.frame.size.width * 230) / 320;
    int imgPosx = (self.view.frame.size.width * 56) / 320;
    
    if (self.view.frame.size.width == 320)
        imgHeight = 370;
    
    slide1ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    slide2ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    slide3ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    slide4ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    slide5ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    slide6ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    slide7ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    slide8ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    slide9ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    
    overlay1ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    overlay2ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    overlay3ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    overlay4ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    overlay5ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    overlay6ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    overlay7ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    overlay8ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    overlay9ImgView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    
    UIView *slide1View = [[UIView alloc] initWithFrame:CGRectMake(imgPosx, 0, imgWidth, imgHeight)];
    UIView *slide2View = [[UIView alloc] initWithFrame:CGRectMake(imgPosx + imgWidth2, 0, imgWidth, imgHeight)];
    UIView *slide3View = [[UIView alloc] initWithFrame:CGRectMake(imgPosx + (imgWidth2 * 2), 0, imgWidth, imgHeight)];
    UIView *slide4View = [[UIView alloc] initWithFrame:CGRectMake(imgPosx + (imgWidth2 * 3), 0, imgWidth, imgHeight)];
    UIView *slide5View = [[UIView alloc] initWithFrame:CGRectMake(imgPosx + (imgWidth2 * 4), 0, imgWidth, imgHeight)];
    UIView *slide6View = [[UIView alloc] initWithFrame:CGRectMake(imgPosx + (imgWidth2 * 5), 0, imgWidth, imgHeight)];
    UIView *slide7View = [[UIView alloc] initWithFrame:CGRectMake(imgPosx + (imgWidth2 * 6), 0, imgWidth, imgHeight)];
    UIView *slide8View = [[UIView alloc] initWithFrame:CGRectMake(imgPosx + (imgWidth2 * 7), 0, imgWidth, imgHeight)];
    UIView *slide9View = [[UIView alloc] initWithFrame:CGRectMake(imgPosx + (imgWidth2 * 8), 0, imgWidth, imgHeight)];
    
    [slide1View addSubview:slide1ImgView];
    [slide2View addSubview:slide2ImgView];
    [slide3View addSubview:slide3ImgView];
    [slide4View addSubview:slide4ImgView];
    [slide5View addSubview:slide5ImgView];
    [slide6View addSubview:slide6ImgView];
    [slide7View addSubview:slide7ImgView];
    [slide8View addSubview:slide8ImgView];
    [slide9View addSubview:slide9ImgView];
    
    [slide1View addSubview:overlay1ImgView];
    [slide2View addSubview:overlay2ImgView];
    [slide3View addSubview:overlay3ImgView];
    [slide4View addSubview:overlay4ImgView];
    [slide5View addSubview:overlay5ImgView];
    [slide6View addSubview:overlay6ImgView];
    [slide7View addSubview:overlay7ImgView];
    [slide8View addSubview:overlay8ImgView];
    [slide9View addSubview:overlay9ImgView];
    
    [slide1View addSubview:self.slide1Btn];
    [slide2View addSubview:self.slide2Btn];
    [slide3View addSubview:self.slide3Btn];
    [slide4View addSubview:self.slide4Btn];
    [slide5View addSubview:self.slide5Btn];
    [slide6View addSubview:self.slide6Btn];
    [slide7View addSubview:self.slide7Btn];
    [slide8View addSubview:self.slide8Btn];
    [slide9View addSubview:self.slide9Btn];
    
    self.slider = [[UIView alloc] initWithFrame:CGRectMake(0, 125, imgPosx + (imgWidth2 * 8) + imgWidth, imgHeight)];
    [self.slider addSubview:slide1View];
    [self.slider addSubview:slide2View];
    [self.slider addSubview:slide3View];
    [self.slider addSubview:slide4View];
    [self.slider addSubview:slide5View];
    [self.slider addSubview:slide6View];
    [self.slider addSubview:slide7View];
    [self.slider addSubview:slide8View];
    [self.slider addSubview:slide9View];
    
    // Set Title
    self.catTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, 20)];
    self.catTitle.text = @"Mode";
    self.catTitle.textColor = [UIColor whiteColor];
    self.catTitle.textAlignment = NSTextAlignmentCenter;
    [self.catTitle setFont:[UIFont fontWithName:@"Apercu-Bold" size:19]];
    
    [self.view addSubview:self.slider];
    [self.view addSubview:self.catTitle];
    
    self.currentSlide = 1;
    
    UISwipeGestureRecognizer *gestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sliderSwipeLeft)];
    UISwipeGestureRecognizer *gestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sliderSwipeRight)];
    [gestureRecognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [gestureRecognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:gestureRecognizerLeft];
    [[self view] addGestureRecognizer:gestureRecognizerRight];
}

- (void)selectCategory:(id)sender {
    [sender setSelected:![sender isSelected]];
    
    UIButton* btn = (UIButton*)sender;
    
    if ([sender isSelected]) {
        [btn.superview.subviews[1] setHidden:[sender isSelected]];
        self.nSelected++;
    } else {
        [btn.superview.subviews[1] setHidden:[sender isSelected]];
        self.nSelected--;
    }
}

- (void)setCategorySelected:(int)index {
    switch (index) {
        case 1:
            [self.slide1Btn.superview.subviews[1] setHidden:YES];
            [self.slide1Btn setSelected:YES];
            break;
        case 2:
            [self.slide2Btn.superview.subviews[1] setHidden:YES];
            [self.slide2Btn setSelected:YES];
            break;
        case 3:
            [self.slide3Btn.superview.subviews[1] setHidden:YES];
            [self.slide3Btn setSelected:YES];
            break;
        case 4:
            [self.slide5Btn.superview.subviews[1] setHidden:YES];
            [self.slide5Btn setSelected:YES];
            break;
        case 5:
            [self.slide7Btn.superview.subviews[1] setHidden:YES];
            [self.slide7Btn setSelected:YES];
            break;
        case 6:
            [self.slide6Btn.superview.subviews[1] setHidden:YES];
            [self.slide6Btn setSelected:YES];
            break;
        case 7:
            [self.slide4Btn.superview.subviews[1] setHidden:YES];
            [self.slide4Btn setSelected:YES];
            break;
        case 8:
            [self.slide9Btn.superview.subviews[1] setHidden:YES];
            [self.slide9Btn setSelected:YES];
            break;
        case 9:
            [self.slide8Btn.superview.subviews[1] setHidden:YES];
            [self.slide8Btn setSelected:YES];
            break;
    }
    
    if (index != 0)
        self.nSelected++;
}

- (void)sliderSwipeRight {
    if (self.currentSlide > 1) {
        CGRect viewFrame = self.slider.frame;
        viewFrame.origin.x += (self.view.frame.size.width * 230) / 320;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.slider.frame = viewFrame;
        
        [UIView commitAnimations];
        
        self.currentSlide--;
        
        switch (self.currentSlide) {
            case 1:
                self.catTitle.text = @"Mode";
                break;
            case 2:
                self.catTitle.text = @"Beauté";
                break;
            case 3:
                self.catTitle.text = @"DIY";
                break;
            case 4:
                self.catTitle.text = @"Food";
                break;
            case 5:
                self.catTitle.text = @"Voyages";
                break;
            case 6:
                self.catTitle.text = @"Fitness";
                break;
            case 7:
                self.catTitle.text = @"Décoration";
                break;
            case 8:
                self.catTitle.text = @"Famille";
                break;
            case 9:
                self.catTitle.text = @"Mariage";
                break;
        }
    }
}

- (void)sliderSwipeLeft {
    if (self.currentSlide < 9) {
        CGRect viewFrame = self.slider.frame;
        viewFrame.origin.x -= (self.view.frame.size.width * 230) / 320;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.slider.frame = viewFrame;
        
        [UIView commitAnimations];
        
        self.currentSlide++;
        
        switch (self.currentSlide) {
            case 1:
                self.catTitle.text = @"Mode";
                break;
            case 2:
                self.catTitle.text = @"Beauté";
                break;
            case 3:
                self.catTitle.text = @"DIY";
                break;
            case 4:
                self.catTitle.text = @"Food";
                break;
            case 5:
                self.catTitle.text = @"Voyages";
                break;
            case 6:
                self.catTitle.text = @"Fitness";
                break;
            case 7:
                self.catTitle.text = @"Décoration";
                break;
            case 8:
                self.catTitle.text = @"Famille";
                break;
            case 9:
                self.catTitle.text = @"Mariage";
                break;
        }
    }
}

@end
