//
//  PageFourViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 16/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"
#import "HomeViewController.h"
#import "PageFourViewController.h"
#import "ArticleViewController.h"
#import "CommentsViewController.h"
#import "BloggerProfileViewController.h"
#import "DBManager.h"
#import "Localization.h"

@interface PageFourViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation PageFourViewController

@synthesize responseData = _responseData;
@synthesize userData = _userData;
@synthesize articlesData = _articlesData;
@synthesize totalArticles = _totalArticles;
@synthesize currentArticle = _currentArticle;
@synthesize likeButton = _likeButton;
@synthesize lastLoadedArticle = _lastLoadedArticle;

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
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"copines.sql"];
    
    User *user = [User getInstance];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.previousPage = 0;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    [self.scrollView setDelegate:self];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.userInteractionEnabled = YES;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(pullToUpdate:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:refreshControl];
    
    self.scrollView.contentSize = CGSizeMake(screenRect.size.width, screenRect.size.height);
    
    [self parseCopines:user.userId];
    self.hvc = (HomeViewController*)self.parentViewController;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarTappedAction:)
                                                 name:kStatusBarTappedNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    self.hvc.pageControl.currentPage = 3;
    [self.hvc drawTitle:4];
    
    // Change the status of the like button
    [self setParentStatus];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kStatusBarTappedNotification object:nil];
}

- (void)statusBarTappedAction:(NSNotification*)notification {
    if (self.scrollView.scrollEnabled)
        [self scrollToTop];
}

- (void)setParentStatus {
    @try {
        NSInteger *ownLike = [[_articlesData[_currentArticle] objectForKey:@"own_like"] intValue];
        NSString *articleLikes = [_articlesData[_currentArticle] objectForKey:@"article_likes"];
        NSString *articleComments = [_articlesData[_currentArticle] objectForKey:@"article_comments"];
        
        HomeViewController *myHomeViewController = (HomeViewController *)self.parentViewController;
        
        if (ownLike)
            [myHomeViewController.likeButton setSelected:YES];
        else
            [myHomeViewController.likeButton setSelected:NO];
        
        [myHomeViewController.likesLabel setText:articleLikes];
        [myHomeViewController.commentsLabel setText:articleComments];
    }
    @catch (NSException *e) {
        NSLog(@"Exception");
        NSLog(@"%@", e);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setScrollEnabled:(BOOL)enabled {
    [self.scrollView setScrollEnabled:enabled];
}

- (void)scrollToTop {
    [self.scrollView setContentOffset: CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:1];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            User *user = [User getInstance];
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
            HomeViewController *myHomeViewController = (HomeViewController *)self.parentViewController;
            
            [refreshControl addTarget:self action:@selector(pullToUpdate:) forControlEvents:UIControlEventValueChanged];
            
            [self.scrollView removeFromSuperview];
            
            self.previousPage = 0;
            _lastLoadedArticle = nil;
            
            self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
            [self.scrollView setDelegate:self];
            [self.scrollView setScrollEnabled:YES];
            [self.scrollView setPagingEnabled:YES];
            self.scrollView.userInteractionEnabled = YES;
            [self.scrollView addSubview:refreshControl];
            self.scrollView.contentSize = CGSizeMake(screenRect.size.width, screenRect.size.height);
            
            [self preUpdateCopines:user.userId];
            
            
            [refreshControl endRefreshing];
            
            [myHomeViewController hideNArticlesButton];
            [self updateCopines:user.userId];
            [self setParentStatus];
        });
    });
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageHeight = scrollView.frame.size.height;
    float fractionalPage = scrollView.contentOffset.y / pageHeight;
    NSInteger page = lround(fractionalPage);
    
    if (self.previousPage != page) {
        _currentArticle = (int)page;
        
        if (page > self.previousPage) {
            self.prevArticle = self.views[_currentArticle - 1];
            self.currArticle = self.views[_currentArticle];
            
            if (_currentArticle < _totalArticles - 1) {
                if (_lastLoadedArticle < _currentArticle + 1) {
                    self.nextArticle = [self parseArticle:_currentArticle+1 positionIs:1];
                    [self.scrollView addSubview:self.nextArticle];
                    
                    CGRect screenRect = [[UIScreen mainScreen] bounds];
                    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, screenRect.size.height * (_lastLoadedArticle + 1));
                } else
                    self.nextArticle = self.views[_currentArticle + 1];
            } else
                self.nextArticle = nil;
        } else if (page < self.previousPage) {
            if (_currentArticle > 0)
                self.prevArticle = self.views[_currentArticle - 1];
            else
                self.prevArticle = nil;
            self.currArticle = self.views[_currentArticle];
            self.nextArticle = self.views[_currentArticle + 1];
        }
        
        self.previousPage = page;
    }
    
    //self.hvc.currentArticle4 = _currentArticle;
    
    // Change the status of the like button
    [self setParentStatus];
}

- (void)pullToUpdate:(UIRefreshControl *)refreshControl {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        User *user = [User getInstance];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        
        [refreshControl addTarget:self action:@selector(pullToUpdate:) forControlEvents:UIControlEventValueChanged];
        
        [self.scrollView removeFromSuperview];
        self.previousPage = 0;
        _lastLoadedArticle = nil;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
        [self.scrollView setDelegate:self];
        [self.scrollView setScrollEnabled:YES];
        [self.scrollView setPagingEnabled:YES];
        self.scrollView.userInteractionEnabled = YES;
        [self.scrollView addSubview:refreshControl];
        self.scrollView.contentSize = CGSizeMake(screenRect.size.width, screenRect.size.height);
        
        [self preUpdateCopines:user.userId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [refreshControl endRefreshing];
            
            [self updateCopines:user.userId];
            [self setParentStatus];
        });
    });
}

- (void)parseCopines:(NSInteger)userId {
    User *user = [User getInstance];
    
    //NSString *sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getFeedByCat?id=%d&cat=%ld", userId, (long)user.theme3];
    NSString *sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getFeedByCat?id=%ld&cat=%d", (long)userId, 3];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    _articlesData = [res objectForKey:@"feed"];
    _totalArticles = [[res objectForKey:@"count"] integerValue];
    _currentArticle = 0;
    
    HomeViewController *myHomeViewController = (HomeViewController *)self.parentViewController;
    //myHomeViewController.lastUpdate4 = [res objectForKey:@"date"];
    
    //self.hvc.articlesData4 = _articlesData;
    //self.hvc.currentArticle4 = _currentArticle;
    
    self.views = [[NSMutableArray alloc] init];
    
    if (_totalArticles) {
        self.currArticle = [self parseArticle:_currentArticle positionIs:0];
        
        if (_currentArticle < _totalArticles && _totalArticles > 1)
            self.nextArticle = [self parseArticle:_currentArticle+1 positionIs:1];
        
        for (UIView *view in [self.view subviews])
            [view removeFromSuperview];
        
        [self.scrollView addSubview:self.currArticle];
        if (self.nextArticle != NULL) {
            [self.scrollView addSubview:self.nextArticle];
            
            self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height * 2);
        }
    } else
        [_backgroundImageView setHidden:FALSE];
    
    [self.view addSubview:self.scrollView];
}

- (void)preUpdateCopines:(NSInteger)userId {
    User *user = [User getInstance];
    
    //NSString *sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getFeedByCat?id=%ld&cat=%ld", (long)userId, (long)user.theme3];
    NSString *sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getFeedByCat?id=%ld&cat=%d", (long)userId, 3];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    _articlesData = [res objectForKey:@"feed"];
    _totalArticles = [[res objectForKey:@"count"] integerValue];
    _currentArticle = 0;
    
    HomeViewController *myHomeViewController = (HomeViewController *)self.parentViewController;
    //myHomeViewController.lastUpdate4 = [res objectForKey:@"date"];
    
    //self.hvc.articlesData4 = _articlesData;
    //self.hvc.currentArticle4 = _currentArticle;
    
    self.views = [[NSMutableArray alloc] init];
}

- (void)updateCopines:(NSInteger)userId {
    if (_totalArticles) {
        self.currArticle = [self parseArticle:_currentArticle positionIs:0];
        
        if (_currentArticle < _totalArticles && _totalArticles > 1)
            self.nextArticle = [self parseArticle:_currentArticle+1 positionIs:1];
        
        for (UIView *view in [self.view subviews])
            [view removeFromSuperview];
        
        [self.scrollView addSubview:self.currArticle];
        if (self.nextArticle != NULL) {
            [self.scrollView addSubview:self.nextArticle];
            
            self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height * 2);
        }
    } else
        [_backgroundImageView setHidden:FALSE];
    
    [self.view addSubview:self.scrollView];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else {
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (UIView*)parseArticle:(int)index positionIs:(int)next {
    if (index > _lastLoadedArticle)
        _lastLoadedArticle = index;
    
    // Set the Article View
    UIView *articleView;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    articleView = [[UIView alloc] initWithFrame:CGRectMake(0, screenRect.size.height * index, screenRect.size.width, screenRect.size.height)];
    
    NSString *blogTitle = [_articlesData[index] objectForKey:@"blog_name"];
    NSString *articleName = [_articlesData[index] objectForKey:@"article_title"];
    NSString *photo = [_articlesData[index] objectForKey:@"article_photo"];
    NSString *profilePhoto = [_articlesData[index] objectForKey:@"user_photo"];
    NSString *articleContent = [_articlesData[index] objectForKey:@"article_content"];
    NSString *dateString = [_articlesData[index] objectForKey:@"article_created_at"];
    //NSString *newArticles = @"";
    
    NSDateFormatter *inputFmt = [[NSDateFormatter alloc] init];
    NSDateFormatter *outputFmt = [[NSDateFormatter alloc] init];
    [inputFmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [outputFmt setDateFormat:@"d MMMM yyyy"];
    [outputFmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"]];
    NSDate *dateFromString = [inputFmt dateFromString:dateString];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 315)];
    
    // Cover Photo Pre Loader
    CAGradientLayer *gradient = [CAGradientLayer layer];
    UIColor *blackGColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.46];
    UIColor *whiteGColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    gradient.frame = CGRectMake(0, 0, self.view.frame.size.width, 315);
    gradient.colors = [NSArray arrayWithObjects:(id)[blackGColor CGColor], (id)[whiteGColor CGColor], nil];
    [imageView.layer insertSublayer:gradient atIndex:0];
    
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loader.alpha = 1.0;
    loader.center = CGPointMake(self.view.frame.size.width / 2, 100);
    loader.hidesWhenStopped = NO;
    
    [imageView addSubview:loader];
    [loader startAnimating];
    
    // Cover Photo
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewArticle)];
    singleTap.numberOfTapsRequired = 1;
    imageView.userInteractionEnabled = YES;
    imageView.tag = 99;
    [imageView addGestureRecognizer:singleTap];
    
    if (photo != (id)[NSNull null]) {
        id path = photo;
        NSURL *imageUrl = [NSURL URLWithString:path];
        
        [self downloadImageWithURL:imageUrl completionBlock:^(BOOL succeeded, UIImage *img) {
            if (succeeded) {
                float imgWidth = (img.size.width * 315) / img.size.height;
                float imgPos = (imgWidth - self.view.frame.size.width) / 2;
                
                CGSize newSize = CGSizeMake(imgWidth, 315);
                UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
                [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                CGRect cropRect = CGRectMake(imgPos, 0, self.view.frame.size.width, 315);
                CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], cropRect);
                UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
                CGImageRelease(imageRef);
                
                UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:finalImage];
                [imageView addSubview:tmpImageView];
                
                if (photo.length) {
                    [imageView.layer insertSublayer:gradient atIndex:3];
                    [loader setHidden:YES];
                }
            }
        }];
    } else {
        [imageView setImage:[UIImage imageNamed:@"default_article.jpg"]];
        [loader setHidden:YES];
    }
    
    // Profile Photo
    if (profilePhoto != (id)[NSNull null]) {
        id path2 = profilePhoto;
        NSURL *profileImageUrl = [NSURL URLWithString:path2];
        NSData *profileImageData = [NSData dataWithContentsOfURL:profileImageUrl];
        UIImage *profileImg = [[UIImage alloc] initWithData:profileImageData];
        
        self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(((self.view.frame.size.width / 2) - 35), 280, 70, 70)];
        [self.profileImageView setImage:profileImg];
    }
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBloggerProfile)];
    singleTap2.numberOfTapsRequired = 1;
    self.profileImageView.userInteractionEnabled = YES;
    self.profileImageView.tag = 99;
    [self.profileImageView addGestureRecognizer:singleTap2];
    
    // Article Date
    UILabel *articleDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 355, self.view.frame.size.width, 30)];
    [articleDateLabel setTextColor:[UIColor blackColor]];
    [articleDateLabel setFont:[UIFont fontWithName:@"TimesNewRomanPSMT" size:11]];
    [articleDateLabel setTextAlignment:NSTextAlignmentCenter];
    articleDateLabel.text = [[outputFmt stringFromDate:dateFromString] uppercaseString];
    
    // Article Name
    UILabel *articleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 380, self.view.frame.size.width - 20, 30)];
    [articleNameLabel setTextColor:[UIColor blackColor]];
    [articleNameLabel setFont:[UIFont fontWithName:@"Apercu" size:21]];
    [articleNameLabel setTextAlignment:NSTextAlignmentCenter];
    articleNameLabel.text = articleName;
    
    // Blog Title
    UILabel *blogTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 410, self.view.frame.size.width - 20, 25)];
    [blogTitleLabel setFont:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:14]];
    [blogTitleLabel setTextColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1]];
    [blogTitleLabel setTextAlignment:NSTextAlignmentCenter];
    blogTitleLabel.text = [@"Par " stringByAppendingString:blogTitle];
    
    // Article Content
    if (self.view.frame.size.width == 320)
        self.articleContentView = [[UITextView alloc] initWithFrame:CGRectMake(10, 445, self.view.frame.size.width - 20, (self.view.frame.size.height - 23) - 445)];
    else
        self.articleContentView = [[UITextView alloc] initWithFrame:CGRectMake(10, 445, self.view.frame.size.width - 20, (self.view.frame.size.height - 34) - 445)];
    [self.articleContentView setEditable:FALSE];
    [self.articleContentView setScrollEnabled:FALSE];
    [self.articleContentView setTextColor:[UIColor blackColor]];
    self.articleContentView.tag = 99;
    self.articleContentView.userInteractionEnabled = YES;
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    paragrahStyle.lineSpacing = 7;
    if (self.view.frame.size.width == 320)
        paragrahStyle.lineSpacing = 6;
    paragrahStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attrsDictionary = @{
                                      NSParagraphStyleAttributeName: paragrahStyle,
                                      NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:16],
                                      };
    self.articleContentView.attributedText = [[NSAttributedString alloc] initWithString:[self stringByStrippingHTML:articleContent] attributes:attrsDictionary];
    
    // Page Count
    UILabel *pageCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 30, self.view.frame.size.width - 20, 23)];
    [pageCountLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:14]];
    [pageCountLabel setTextColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1]];
    [pageCountLabel setTextAlignment:NSTextAlignmentRight];
    pageCountLabel.text = [[[NSString stringWithFormat:@"%d", index + 1] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%d", _totalArticles]];
    
    [articleView addSubview:imageView];
    [articleView addSubview:self.profileImageView];
    [articleView addSubview:articleDateLabel];
    [articleView addSubview:articleNameLabel];
    [articleView addSubview:blogTitleLabel];
    [articleView addSubview:self.articleContentView];
    [articleView addSubview:pageCountLabel];
    
    [self.views addObject:articleView];
    
    return articleView;
}

- (void)likeArticle {
    int likes = [[_articlesData[_currentArticle] objectForKey:@"article_likes"] intValue];
    int own_like = [[_articlesData[_currentArticle] objectForKey:@"own_like"] intValue];
    
    own_like = !own_like;
    
    //UIButton *btn = (UIButton*)[_currArticle viewWithTag:80];
    //UILabel *lbl = (UILabel*)[_currArticle viewWithTag:81];
    NSString *sUrl;
    
    User *user = [User getInstance];
    HomeViewController *myHomeViewController = (HomeViewController *)self.parentViewController;
    
    if (myHomeViewController.likeButton.selected) {
        likes = likes - 1;
        
        myHomeViewController.likesLabel.text = [NSString stringWithFormat:@"%ld", myHomeViewController.likesLabel.text.integerValue - 1];
        sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/unlikeArticle?id=%@&user=%ld", [_articlesData[_currentArticle] objectForKey:@"article_id"], (long)user.userId];
    } else {
        likes = likes + 1;
        
        myHomeViewController.likesLabel.text = [NSString stringWithFormat:@"%ld", myHomeViewController.likesLabel.text.integerValue + 1];
        sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/likeArticle?id=%@&user=%ld", [_articlesData[_currentArticle] objectForKey:@"article_id"], (long)user.userId];
    }
    
    [myHomeViewController.likeButton setSelected:!myHomeViewController.likeButton.selected];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    [_articlesData[_currentArticle] setValue:[NSString stringWithFormat:@"%d", likes] forKey:@"article_likes"];
    [_articlesData[_currentArticle] setValue:[NSString stringWithFormat:@"%d", own_like] forKey:@"own_like"];
}

- (void)commentArticle {
    CommentsViewController *viewController = [[CommentsViewController alloc] init];
    
    viewController.responseData = _responseData;
    viewController.userData = _userData;
    viewController.articleData = _articlesData[_currentArticle];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewBloggerProfile {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BloggerProfileViewController *viewController = (BloggerProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BloggerProfileViewController"];
    
    viewController.articleData = _articlesData[_currentArticle];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSString *)stringByStrippingHTML:(NSString *)s {
    NSRange r;
    
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    
    s = [s stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    s = [s stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    return s;
}

-(void) viewArticle {
    if (!self.hvc.menuVisible) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ArticleViewController *viewController = (ArticleViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ArticleViewController"];
        
        viewController.userData = _userData;
        viewController.articleData = _articlesData[_currentArticle];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
