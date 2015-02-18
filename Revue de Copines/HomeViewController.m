//
//  HomeViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 14/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "SubscriptionViewController.h"
#import "HomeViewController.h"
#import "PageViewController.h"
#import "PageOneViewController.h"
#import "BloggerFeedViewController.h"
#import "PageScrollViewController.h"
#import "AddCategoriesViewController.h"
#import "DiscoverViewController.h"
#import "ManageBlogViewController.h"
#import "ManageProfileViewController.h"
#import "BloggerProfileViewController.h"
#import "User.h"
#import "Localization.h"
#import <QuartzCore/QuartzCore.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    
    self.dataSource = self;
    
    self.theStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Set custom left bar button
    UIImage *buttonImage = [UIImage imageNamed:@"menu_slider.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width / 2, buttonImage.size.height / 2);
    [aButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    
    // Like Button
    UIImage *likeImg1 = [UIImage imageNamed:@"like_line.png"];
    UIImage *likeImg2 = [UIImage imageNamed:@"like.png"];
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton setImage:likeImg1 forState:UIControlStateNormal];
    [self.likeButton setImage:likeImg2 forState:UIControlStateSelected];
    [self.likeButton setImage:likeImg2 forState:UIControlStateHighlighted];
    self.likeButton.frame = CGRectMake(0, 0, 30, 27);
    [self.likeButton addTarget:self action:@selector(likeArticle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.likeButton];
    
    // Comments Button
    UIImage *commentImg = [UIImage imageNamed:@"comment.png"];
    self.commentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentsButton setImage:commentImg forState:UIControlStateNormal];
    if (self.view.frame.size.width == 320)
        self.commentsButton.frame = CGRectMake(self.view.frame.size.width - 46, 85, 30, 27);
    else
        self.commentsButton.frame = CGRectMake(self.view.frame.size.width - ((self.view.frame.size.width * 46) / 375), 85, 30, 27);
    [self.commentsButton addTarget:self action:@selector(commentArticle) forControlEvents:UIControlEventTouchUpInside];
    
    // Likes Label
    if (self.view.frame.size.width == 320)
        self.likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 46, 58, 30, 20)];
    else
        self.likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - ((self.view.frame.size.width * 46) / 375), 58, 30, 20)];
    [self.likesLabel setTextColor:[UIColor whiteColor]];
    [self.likesLabel setFont:[UIFont fontWithName:@"Apercu" size:14]];
    [self.likesLabel setTextAlignment:NSTextAlignmentCenter];
    [self.likesLabel setTag:81];
    //self.likesLabel.text = articleLikes;
    self.likesLabel.text = @"0";
    
    // Comments Label
    if (self.view.frame.size.width == 320)
        self.commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 46, 113, 30, 20)];
    else
        self.commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - ((self.view.frame.size.width * 46) / 375), 113, 30, 20)];
    [self.commentsLabel setTextColor:[UIColor whiteColor]];
    [self.commentsLabel setFont:[UIFont fontWithName:@"Apercu" size:14]];
    [self.commentsLabel setTextAlignment:NSTextAlignmentCenter];
    //self.commentsLabel.text = articleComments;
    self.commentsLabel.text = @"0";
    
    // New Articles
    UIImage *newArticlesImage = [UIImage imageNamed:@"round-button_newarticles"];
    self.nArticlesImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - (newArticlesImage.size.width / 4), 230, newArticlesImage.size.width / 2, newArticlesImage.size.height / 2)];
    [self.nArticlesImageView setImage:newArticlesImage];
    self.nArticlesLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - (newArticlesImage.size.width / 4), 230, newArticlesImage.size.width / 2, newArticlesImage.size.height / 2)];
    [self.nArticlesLabel setTextColor:[UIColor whiteColor]];
    [self.nArticlesLabel setFont:[UIFont fontWithName:@"Apercu" size:14]];
    [self.nArticlesLabel setTextAlignment:NSTextAlignmentCenter];
    self.nArticlesLabel.text = @"nouveaux articles";
    
    UITapGestureRecognizer *nArticlesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToTop)];
    nArticlesTap.numberOfTapsRequired = 1;
    self.nArticlesImageView.userInteractionEnabled = YES;
    [self.nArticlesImageView addGestureRecognizer:nArticlesTap];
    [self hideNArticlesButton];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.view addSubview:self.commentsButton];
    [self.view addSubview:self.likesLabel];
    [self.view addSubview:self.commentsLabel];
    [self.view addSubview:self.nArticlesImageView];
    [self.view addSubview:self.nArticlesLabel];
    
    // Set custom title view
    [self drawTitle:1];
    
    // Set transparent bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    self.mainPageViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"one"];
    self.pageOneViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageTwoViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageThreeViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageFourViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageFiveViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageSixViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageSevenViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageEightViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageNineViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    
    self.mainPageViewController.navItem = self.navigationItem;
    self.pageOneViewController.navItem = self.navigationItem;
    self.pageTwoViewController.navItem = self.navigationItem;
    self.pageThreeViewController.navItem = self.navigationItem;
    self.pageFourViewController.navItem = self.navigationItem;
    self.pageFiveViewController.navItem = self.navigationItem;
    self.pageSixViewController.navItem = self.navigationItem;
    self.pageSevenViewController.navItem = self.navigationItem;
    self.pageEightViewController.navItem = self.navigationItem;
    self.pageNineViewController.navItem = self.navigationItem;
    
    self.pageOneViewController.pageNumber = 1;
    self.pageTwoViewController.pageNumber = 2;
    self.pageThreeViewController.pageNumber = 3;
    self.pageFourViewController.pageNumber = 4;
    self.pageFiveViewController.pageNumber = 5;
    self.pageSixViewController.pageNumber = 6;
    self.pageSevenViewController.pageNumber = 7;
    self.pageEightViewController.pageNumber = 8;
    self.pageNineViewController.pageNumber = 9;
    
    self.lastUpdate = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    
    self.pages = [[NSMutableArray alloc] init];
    [self.pages addObject:self.mainPageViewController];
    
    User *user = [User getInstance];
    
    int index = 1;
    for (NSString *userTheme in user.themes) {
        int theme = [userTheme intValue];
        
        if (theme != 0) {
            if (theme == 1) {
                [self.pages addObject:self.pageOneViewController];
                self.pageOneViewController.realPageNumber = index;
            } else if (theme == 2) {
                [self.pages addObject:self.pageTwoViewController];
                self.pageTwoViewController.realPageNumber = index;
            } else if (theme == 3) {
                [self.pages addObject:self.pageThreeViewController];
                self.pageThreeViewController.realPageNumber = index;
            } else if (theme == 4) {
                [self.pages addObject:self.pageFourViewController];
                self.pageFourViewController.realPageNumber = index;
            } else if (theme == 5) {
                [self.pages addObject:self.pageFiveViewController];
                self.pageFiveViewController.realPageNumber = index;
            } else if (theme == 6) {
                [self.pages addObject:self.pageSixViewController];
                self.pageSixViewController.realPageNumber = index;
            } else if (theme == 7) {
                [self.pages addObject:self.pageSevenViewController];
                self.pageSevenViewController.realPageNumber = index;
            } else if (theme == 8) {
                [self.pages addObject:self.pageEightViewController];
                self.pageEightViewController.realPageNumber = index;
            } else if (theme == 9) {
                [self.pages addObject:self.pageNineViewController];
                self.pageNineViewController.realPageNumber = index;
            }
            
            index++;
        }
    }
    
    for (int i = ((int)self.pages.count - 1); i >= 0; i--)
        [self setViewControllers:[NSArray arrayWithObject:[self.pages objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self createMenu];
    [self setPageControll];
    
    // Set timer for updates check
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(checkUpdates) userInfo:nil repeats:YES];
}

- (void)reinitCategoriesLoading {
    Localization *localization = [[Localization alloc] init];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = [localization getStringForText:@"updating categories" forLocale:@"fr"];
    self.hud.detailsLabelText = [localization getStringForText:@"please wait" forLocale:@"fr"];
}

- (void)reinitCategories {
    [self drawTitle:1];
    
    self.mainPageViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"one"];
    self.pageOneViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageTwoViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageThreeViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageFourViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageFiveViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageSixViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageSevenViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageEightViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    self.pageNineViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"two"];
    
    self.mainPageViewController.navItem = self.navigationItem;
    self.pageOneViewController.navItem = self.navigationItem;
    self.pageTwoViewController.navItem = self.navigationItem;
    self.pageThreeViewController.navItem = self.navigationItem;
    self.pageFourViewController.navItem = self.navigationItem;
    self.pageFiveViewController.navItem = self.navigationItem;
    self.pageSixViewController.navItem = self.navigationItem;
    self.pageSevenViewController.navItem = self.navigationItem;
    self.pageEightViewController.navItem = self.navigationItem;
    self.pageNineViewController.navItem = self.navigationItem;
    
    self.pageOneViewController.pageNumber = 1;
    self.pageTwoViewController.pageNumber = 2;
    self.pageThreeViewController.pageNumber = 3;
    self.pageFourViewController.pageNumber = 4;
    self.pageFiveViewController.pageNumber = 5;
    self.pageSixViewController.pageNumber = 6;
    self.pageSevenViewController.pageNumber = 7;
    self.pageEightViewController.pageNumber = 8;
    self.pageNineViewController.pageNumber = 9;
    
    self.lastUpdate = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    
    self.pages = [[NSMutableArray alloc] init];
    [self.pages addObject:self.mainPageViewController];
    
    User *user = [User getInstance];
    
    int index = 1;
    for (NSString *userTheme in user.themes) {
        int theme = [userTheme intValue];
        
        if (theme != 0) {
            if (theme == 1) {
                [self.pages addObject:self.pageOneViewController];
                self.pageOneViewController.realPageNumber = index;
            } else if (theme == 2) {
                [self.pages addObject:self.pageTwoViewController];
                self.pageTwoViewController.realPageNumber = index;
            } else if (theme == 3) {
                [self.pages addObject:self.pageThreeViewController];
                self.pageThreeViewController.realPageNumber = index;
            } else if (theme == 4) {
                [self.pages addObject:self.pageFourViewController];
                self.pageFourViewController.realPageNumber = index;
            } else if (theme == 5) {
                [self.pages addObject:self.pageFiveViewController];
                self.pageFiveViewController.realPageNumber = index;
            } else if (theme == 6) {
                [self.pages addObject:self.pageSixViewController];
                self.pageSixViewController.realPageNumber = index;
            } else if (theme == 7) {
                [self.pages addObject:self.pageSevenViewController];
                self.pageSevenViewController.realPageNumber = index;
            } else if (theme == 8) {
                [self.pages addObject:self.pageEightViewController];
                self.pageEightViewController.realPageNumber = index;
            } else if (theme == 9) {
                [self.pages addObject:self.pageNineViewController];
                self.pageNineViewController.realPageNumber = index;
            }
            
            index++;
        }
    }
    
    for (int i = ((int)self.pages.count - 1); i >= 0; i--)
        [self setViewControllers:[NSArray arrayWithObject:[self.pages objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self setPageControll];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)likeArticle {
    if (self.pageControl.currentPage == 0)
        [self.mainPageViewController likeArticle];
    else {
        PageViewController *pvc = (PageViewController*) self.pages[self.pageControl.currentPage];
        
        [pvc likeArticle];
    }
}

- (void)commentArticle {
    if (self.pageControl.currentPage == 0)
        [self.mainPageViewController commentArticle];
    else {
        PageViewController *pvc = (PageViewController*) self.pages[self.pageControl.currentPage];
        
        [pvc commentArticle];
    }
}

- (void)scrollToTop {
    if (self.pageControl.currentPage == 0)
        [self.mainPageViewController scrollToTop];
    else {
        PageViewController *pvc = (PageViewController*) self.pages[self.pageControl.currentPage];
        
        [pvc scrollToTop];
    }
    
    [self hideNArticlesButton];
}

- (void)hideNArticlesButton {
    [self.nArticlesLabel setHidden:YES];
    [self.nArticlesImageView setHidden:YES];
}

- (void)checkUpdates {
    User *user = [User getInstance];
    NSString *sUrl;
    
    if (self.pageControl.currentPage == 0)
        sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getUpdates?id=%ld&cat=copines&date=%@", (long)user.userId, self.lastUpdate[0]];
    else {
        PageViewController *pvc = (PageViewController*) self.pages[self.pageControl.currentPage];
        
        int realPageNumber = pvc.realPageNumber;
        
        if (realPageNumber == 1)
            sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getUpdates?id=%ld&cat=mode&date=%@", (long)user.userId, self.lastUpdate[1]];
        else if (realPageNumber == 2)
            sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getUpdates?id=%ld&cat=beaute&date=%@", (long)user.userId, self.lastUpdate[2]];
        else if (realPageNumber == 3)
            sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getUpdates?id=%ld&cat=DIY&date=%@", (long)user.userId, self.lastUpdate[3]];
        else if (realPageNumber == 4)
            sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getUpdates?id=%ld&cat=voyages&date=%@", (long)user.userId, self.lastUpdate[4]];
        else if (realPageNumber == 5)
            sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getUpdates?id=%ld&cat=decoration&date=%@", (long)user.userId, self.lastUpdate[5]];
        else if (realPageNumber == 6)
            sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getUpdates?id=%ld&cat=fitness&date=%@", (long)user.userId, self.lastUpdate[6]];
        else if (realPageNumber == 7)
            sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getUpdates?id=%ld&cat=food&date=%@", (long)user.userId, self.lastUpdate[7]];
        else if (realPageNumber == 8)
            sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getUpdates?id=%ld&cat=mariage&date=%@", (long)user.userId, self.lastUpdate[8]];
        else if (realPageNumber == 9)
            sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getUpdates?id=%ld&cat=famille&date=%@", (long)user.userId, self.lastUpdate[9]];
    }
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    int count = [[res objectForKey:@"count"] integerValue];
    
    if (count > 0) {
        [self.nArticlesLabel setHidden:NO];
        [self.nArticlesImageView setHidden:NO];
    }
}

- (void)setPageControll {
    self.pageControl = [[UIPageControl alloc] init];
    
    self.pageControl.frame = CGRectMake(100, 49, self.view.frame.size.width - 200, 10);
    self.pageControl.numberOfPages = self.pages.count;
    self.pageControl.currentPage = 0;
    
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UIPageControl class]])
            [v removeFromSuperview];
    }
    
    [self.view addSubview:self.pageControl];
}

- (void)setScrollEnabled:(BOOL)enabled {
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*) view;
            [scrollView setScrollEnabled:enabled];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createMenu {
    User *user = [User getInstance];
    
    NSString *sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getCopinesList?id=%ld", (long)user.userId];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    self.copinesData = res;
    
    int menuWidth = (self.view.frame.size.width * 280 ) / 320;
    self.menu = [[UIView alloc] initWithFrame:CGRectMake(-menuWidth, 0, menuWidth, self.view.frame.size.height)];
    
    // Background Image
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    UIImageView *backgroundImg = [[UIImageView alloc] initWithImage:backgroundImage];
    backgroundImg.frame = CGRectMake(0, 0, menuWidth, self.view.frame.size.height);
    
    [self.menu addSubview:backgroundImg];
    
    // Disconnect Button
    UIImage *disconnectImage = [UIImage imageNamed:@"disconnect.png"];
    UIButton *disconnectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [disconnectButton setImage:disconnectImage forState:UIControlStateNormal];
    disconnectButton.frame = CGRectMake(18, 28, disconnectImage.size.width / 2, disconnectImage.size.height / 2);
    [disconnectButton addTarget:self action:@selector(disconnect) forControlEvents:UIControlEventTouchUpInside];
    
    [self.menu addSubview:disconnectButton];
    
    // Profile Picture
    UIImageView *profileImageView;
    
    if(user.photo != (id)[NSNull null]) {
        NSString *profilePhoto = user.photo;
        id path = profilePhoto;
        NSURL *profileImageUrl = [NSURL URLWithString:path];
        NSData *profileImageData = [NSData dataWithContentsOfURL:profileImageUrl];
        UIImage *profileImg = [[UIImage alloc] initWithData:profileImageData];
        profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * 105) / 320, 40, (self.view.frame.size.width * 70) / 320, (self.view.frame.size.width * 70) / 320)];
        
        profileImageView.clipsToBounds = YES;
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
        
        [profileImageView setImage:profileImg];
    } else {
        UIImage *profileImg = [UIImage imageNamed:@"default_profile_picture.png"];
        profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * 105) / 320, 40, (self.view.frame.size.width * 70) / 320, (self.view.frame.size.width * 70) / 320)];
        
        profileImageView.clipsToBounds = YES;
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
        
        [profileImageView setImage:profileImg];
    }
    
    // Blog Title
    NSString *blogTitle = [self.pageOneViewController.responseData objectForKey:@"name"];
    UILabel *blogTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 115, menuWidth, 25)];
    [blogTitleLabel setFont:[UIFont fontWithName:@"Apercu-Medium" size:20]];
    [blogTitleLabel setTextColor:[UIColor whiteColor]];
    [blogTitleLabel setTextAlignment:NSTextAlignmentCenter];
    blogTitleLabel.text = blogTitle;
    
    // Manage Blog Button
    UIImage *manageBlogImage = [UIImage imageNamed:@"manage_blog.png"];
    UIButton *manageBlogButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [manageBlogButton setImage:manageBlogImage forState:UIControlStateNormal];
    manageBlogButton.frame = CGRectMake(((self.view.frame.size.width * 140) / 320) - (manageBlogImage.size.width / 4), 150, manageBlogImage.size.width / 2, manageBlogImage.size.height / 2);
    [manageBlogButton addTarget:self action:@selector(manageBlog) forControlEvents:UIControlEventTouchUpInside];
    
    // Manage Profile Button
    UIImage *manageProfileImage = [UIImage imageNamed:@"manage_profile.png"];
    UIButton *manageProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [manageProfileButton setImage:manageProfileImage forState:UIControlStateNormal];
    manageProfileButton.frame = CGRectMake(((self.view.frame.size.width * 140) / 320) - (manageProfileImage.size.width / 4), 150, manageProfileImage.size.width / 2, manageProfileImage.size.height / 2);
    [manageProfileButton addTarget:self action:@selector(manageProfile) forControlEvents:UIControlEventTouchUpInside];
    
    // Line Separator
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 192, menuWidth, 1)];
    [line setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
    
    // Scroll Content
    UIScrollView *scrollContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 193, menuWidth, self.view.frame.size.height - 193)];
    
    // Search
    UIImage *searchImage = [UIImage imageNamed:@"search.png"];
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(33, 0, searchImage.size.width / 2, searchImage.size.height / 2)];
    [searchImageView setImage:searchImage];
    UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, -1, 195, 20)];
    [searchLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:18]];
    [searchLabel setTextColor:[UIColor whiteColor]];
    searchLabel.text = @"Découvrir";
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 22, menuWidth, searchImage.size.height / 2);
    [searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [searchButton addSubview:searchImageView];
    [searchButton addSubview:searchLabel];
    [scrollContent addSubview:searchButton];
    
    // New Category
    UIImage *categoryImage = [UIImage imageNamed:@"follow.png"];
    UIImageView *categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(33, 0, categoryImage.size.width / 3, categoryImage.size.height / 3)];
    [categoryImageView setImage:categoryImage];
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, 195, 20)];
    [categoryLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:18]];
    [categoryLabel setTextColor:[UIColor whiteColor]];
    categoryLabel.text = @"Ajouter des catégories";
    
    UIButton *categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryButton.frame = CGRectMake(0, 66, menuWidth, categoryImage.size.height / 2);
    [categoryButton addTarget:self action:@selector(newCategory) forControlEvents:UIControlEventTouchUpInside];
    [categoryButton addSubview:categoryImageView];
    [categoryButton addSubview:categoryLabel];
    [scrollContent addSubview:categoryButton];
    
    // Mes Copines Sub-Title
    UILabel *copinesLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 108, 230, 20)];
    [copinesLabel setFont:[UIFont fontWithName:@"Apercu-Bold" size:17]];
    [copinesLabel setTextColor:[UIColor whiteColor]];
    copinesLabel.text = @"Mes Copines";
    [scrollContent addSubview:copinesLabel];
    
    // Copines List
    float initY = 150;
    
    int count = [[res objectForKey:@"count"] intValue];
    
    if (count) {
        for (int i = 0; i < count; i++) {
            UIImage *bulletImage = [UIImage imageNamed:@"bullet-point.png"];
            UIImageView *bulletImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 6, bulletImage.size.width / 2, bulletImage.size.height / 2)];
            [bulletImageView setImage:bulletImage];
            
            UILabel *copineLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, 195, 20)];
            [copineLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:18]];
            [copineLabel setTextColor:[UIColor whiteColor]];
            
            copineLabel.text = [[res objectForKey:@"data"][i] objectForKey:@"blog_name"];
            copineLabel.tag = 200;
            
            UIButton *copineButton = [UIButton buttonWithType:UIButtonTypeCustom];
            copineButton.tag = [[[res objectForKey:@"data"][i] objectForKey:@"blog_id"] integerValue];
            copineButton.frame = CGRectMake(0, initY, menuWidth, 20);
            [copineButton addTarget:self action:@selector(viewCopine:) forControlEvents:UIControlEventTouchUpInside];
            [copineButton addSubview:bulletImageView];
            [copineButton addSubview:copineLabel];
            [scrollContent addSubview:copineButton];
            
            initY += 43;
        }
    }
    
    [scrollContent setScrollEnabled:YES];
    [scrollContent setContentSize:CGSizeMake(menuWidth, initY)];
    
    [self.menu addSubview:profileImageView];
    [self.menu addSubview:blogTitleLabel];
    
    if (user.type == 2)
        [self.menu addSubview:manageBlogButton];
    else
        [self.menu addSubview:manageProfileButton];
    
    [self.menu addSubview:line];
    [self.menu addSubview:scrollContent];
    
    // Swipe Left to close Menu
    self.menuSwipeView = [[UIView alloc] initWithFrame:CGRectMake(menuWidth, 0, 40, self.view.frame.size.height)];
    
    UITapGestureRecognizer *closeMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
    UISwipeGestureRecognizer *gestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
    [gestureRecognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    closeMenuTap.numberOfTapsRequired = 1;
    [self.menuSwipeView addGestureRecognizer:closeMenuTap];
    [self.menuSwipeView addGestureRecognizer:gestureRecognizerLeft];
    [[self view] addSubview:self.menuSwipeView];
    
    self.menuVisible = NO;
    [self.menuSwipeView setHidden:YES];
    [self.view addSubview:self.menu];
}

- (void)toggleMenu {
    [self.menuSwipeView setHidden:!self.menuSwipeView.hidden];
    int menuWidth = (self.view.frame.size.width * 280 ) / 320;
    
    CGRect menuFrame = self.menu.frame;
    CGRect navigationFrame = self.navigationController.navigationBar.frame;
    
    CGRect mainPageFrame = self.mainPageViewController.view.frame;
    CGRect pageOneFrame = self.pageOneViewController.view.frame;
    CGRect pageTwoFrame = self.pageTwoViewController.view.frame;
    CGRect pageThreeFrame = self.pageThreeViewController.view.frame;
    CGRect pageFourFrame = self.pageFourViewController.view.frame;
    CGRect pageFiveFrame = self.pageFiveViewController.view.frame;
    CGRect pageSixFrame = self.pageSixViewController.view.frame;
    CGRect pageSevenFrame = self.pageSevenViewController.view.frame;
    CGRect pageEightFrame = self.pageEightViewController.view.frame;
    CGRect pageNineFrame = self.pageNineViewController.view.frame;
    
    CGRect pageControllerFrame = self.pageControl.frame;
    CGRect likesLabelFrame = self.likesLabel.frame;
    CGRect commentsButtonFrame = self.commentsButton.frame;
    CGRect commentsLabelFrame = self.commentsLabel.frame;
    
    if (self.menuVisible) {
        menuFrame.origin.x = -menuWidth;
        navigationFrame.origin.x = 0;
        
        mainPageFrame.origin.x = 0;
        pageOneFrame.origin.x = 0;
        pageTwoFrame.origin.x = 0;
        pageThreeFrame.origin.x = 0;
        pageFourFrame.origin.x = 0;
        pageFiveFrame.origin.x = 0;
        pageSixFrame.origin.x = 0;
        pageSevenFrame.origin.x = 0;
        pageEightFrame.origin.x = 0;
        pageNineFrame.origin.x = 0;
        
        pageControllerFrame.origin.x = 100;
        if (self.view.frame.size.width == 320) {
            likesLabelFrame.origin.x = self.view.frame.size.width - 46;
            commentsButtonFrame.origin.x = self.view.frame.size.width - 46;
            commentsLabelFrame.origin.x = self.view.frame.size.width - 46;
        } else {
            likesLabelFrame.origin.x = self.view.frame.size.width - ((self.view.frame.size.width * 46) / 375);
            commentsButtonFrame.origin.x = self.view.frame.size.width - ((self.view.frame.size.width * 46) / 375);
            commentsLabelFrame.origin.x = self.view.frame.size.width - ((self.view.frame.size.width * 46) / 375);
        }
        
        self.menuVisible = NO;
        [self setScrollEnabled:YES];
        
        [self.mainPageViewController setScrollEnabled:YES];
        [self.pageOneViewController setScrollEnabled:YES];
        [self.pageTwoViewController setScrollEnabled:YES];
        [self.pageThreeViewController setScrollEnabled:YES];
        [self.pageFourViewController setScrollEnabled:YES];
        [self.pageFiveViewController setScrollEnabled:YES];
        [self.pageSixViewController setScrollEnabled:YES];
        [self.pageSevenViewController setScrollEnabled:YES];
        [self.pageEightViewController setScrollEnabled:YES];
        [self.pageNineViewController setScrollEnabled:YES];
    } else {
        menuFrame.origin.x = 0;
        navigationFrame.origin.x = menuWidth;
        
        mainPageFrame.origin.x = menuWidth;
        pageOneFrame.origin.x = menuWidth;
        pageTwoFrame.origin.x = menuWidth;
        pageThreeFrame.origin.x = menuWidth;
        pageFourFrame.origin.x = menuWidth;
        pageFiveFrame.origin.x = menuWidth;
        pageSixFrame.origin.x = menuWidth;
        pageSevenFrame.origin.x = menuWidth;
        pageEightFrame.origin.x = menuWidth;
        pageNineFrame.origin.x = menuWidth;
        
        pageControllerFrame.origin.x = (self.view.frame.size.width * 380) / 320;
        likesLabelFrame.origin.x = (self.view.frame.size.width * 594) / 320;
        commentsButtonFrame.origin.x = (self.view.frame.size.width * 594) / 320;
        commentsLabelFrame.origin.x = (self.view.frame.size.width * 594) / 320;
        
        self.menuVisible = YES;
        [self setScrollEnabled:NO];
        
        [self.mainPageViewController setScrollEnabled:NO];
        [self.pageOneViewController setScrollEnabled:NO];
        [self.pageTwoViewController setScrollEnabled:NO];
        [self.pageThreeViewController setScrollEnabled:NO];
        [self.pageFourViewController setScrollEnabled:NO];
        [self.pageFiveViewController setScrollEnabled:NO];
        [self.pageSixViewController setScrollEnabled:NO];
        [self.pageSevenViewController setScrollEnabled:NO];
        [self.pageEightViewController setScrollEnabled:NO];
        [self.pageNineViewController setScrollEnabled:NO];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.menu.frame = menuFrame;
    self.navigationController.navigationBar.frame = navigationFrame;
    
    self.mainPageViewController.view.frame = mainPageFrame;
    self.pageOneViewController.view.frame = pageOneFrame;
    self.pageTwoViewController.view.frame = pageTwoFrame;
    self.pageThreeViewController.view.frame = pageThreeFrame;
    self.pageFourViewController.view.frame = pageFourFrame;
    self.pageFiveViewController.view.frame = pageFiveFrame;
    self.pageSixViewController.view.frame = pageSixFrame;
    self.pageSevenViewController.view.frame = pageSevenFrame;
    self.pageEightViewController.view.frame = pageEightFrame;
    self.pageNineViewController.view.frame = pageNineFrame;
    
    self.pageControl.frame = pageControllerFrame;
    self.likesLabel.frame = likesLabelFrame;
    self.commentsButton.frame = commentsButtonFrame;
    self.commentsLabel.frame = commentsLabelFrame;
    
    [UIView commitAnimations];
}

- (void)disconnect {
    User *user = [User getInstance];
    
    [user logout];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController *navController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"initialNavigationController"];
    
    appDelegate.window.rootViewController = navController;
}

- (void)manageBlog {
    [self toggleMenu];
    
    ManageBlogViewController *manageBlogViewController;
    manageBlogViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"ManageBlogViewController"];
    
    [self.navigationController pushViewController:manageBlogViewController animated:YES];
}

- (void)manageProfile {
    [self toggleMenu];
    
    ManageProfileViewController *manageProfileViewController;
    manageProfileViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"ManageProfileViewController"];
    
    [self.navigationController pushViewController:manageProfileViewController animated:YES];
}

- (void)search {
    [self toggleMenu];
    
    DiscoverViewController *discoverViewController;
    discoverViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"DiscoverViewController"];
    discoverViewController.hvc = self;
    
    [self.navigationController pushViewController:discoverViewController animated:YES];
}

- (void)newCategory {
    [self toggleMenu];
    
    AddCategoriesViewController *addCategoriesViewController;
    addCategoriesViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"AddCategoriesViewController"];
    [addCategoriesViewController setHomeViewController:self];
    
    [self.navigationController pushViewController:addCategoriesViewController animated:YES];
}

- (void)viewCopine:(UIButton*)button {
    self.bloggerFeedViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"three"];
    self.bloggerFeedViewController.blogId = button.tag;
    
    for (UIView *v in button.subviews) {
        if (v.tag == 200) {
            UILabel *copineLabel = (UILabel*)v;
            
            self.bloggerFeedViewController.blogTitle = copineLabel.text;
        }
    }
    
    [self toggleMenu];
    [self.navigationController pushViewController:self.bloggerFeedViewController animated:YES];
}

- (void)viewCopineFromDiscover:(NSInteger)blogId withTitle:(NSString*)title {
    self.bloggerFeedViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"three"];
    self.bloggerFeedViewController.blogId = blogId;
    
    self.bloggerFeedViewController.blogTitle = title;
    
    //[self toggleMenu];
    [self.navigationController pushViewController:self.bloggerFeedViewController animated:YES];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (self.pageControl.currentPage > 0) {
        if ([self.pages[self.pageControl.currentPage - 1] isKindOfClass:[PageViewController class]]) {
            PageViewController *pvc = (PageViewController*)self.pages[self.pageControl.currentPage - 1];
            
            return pvc;
        } else
            return self.mainPageViewController;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (self.pageControl.currentPage < (self.pages.count - 1)) {
        PageViewController *pvc = (PageViewController*)self.pages[self.pageControl.currentPage + 1];
        
        return pvc;
    }
    
    return nil;
}

- (void) drawTitle:(NSInteger)page {
    // Label
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, 200, 32)];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont fontWithName:@"Apercu-Bold" size:18]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTag:10];
    
    if (page == 1)
        title.text = @"Mes copines";
    else if (page == 2)
        title.text = @"Mode";
    else if (page == 3)
        title.text = @"Beauté";
    else if (page == 4)
        title.text = @"DIY";
    else if (page == 5)
        title.text = @"Voyages";
    else if (page == 6)
        title.text = @"Décoration";
    else if (page == 7)
        title.text = @"Fitness";
    else if (page == 8)
        title.text = @"Food";
    else if (page == 9)
        title.text = @"Mariage";
    else if (page == 10)
        title.text = @"Famille";
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 32)];
    
    [iv setBackgroundColor:[UIColor clearColor]];
    [iv addSubview:title];
    
    self.navigationItem.titleView = iv;
}

@end
