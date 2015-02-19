//
//  ArticleViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 17/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "User.h"
#import "ArticleViewController.h"
#import "BloggerProfileViewController.h"
#import "CommentsViewController.h"
#import "Localization.h"


@interface ArticleViewController ()

@end

@implementation ArticleViewController

@synthesize responseData = _responseData;
@synthesize userData = _userData;
@synthesize articleData = _articleData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set custom left bar button
    UIImage *buttonImage = [UIImage imageNamed:@"back.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width / 2, buttonImage.size.height / 2);
    [aButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.navigationController.navigationBar.translucent = NO;
    
    // Set custom right bar buttons
    UIImage *likeImage = [UIImage imageNamed:@"like_line.png"];
    UIImage *likeImage2 = [UIImage imageNamed:@"fond_blanc.png"];
    UIImage *commentImage = [UIImage imageNamed:@"comment.png"];
    UIImage *shareImage = [UIImage imageNamed:@"share.png"];
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton setImage:likeImage forState:UIControlStateNormal];
    [self.likeButton setImage:likeImage2 forState:UIControlStateSelected];
    [commentButton setImage:commentImage forState:UIControlStateNormal];
    [shareButton setImage:shareImage forState:UIControlStateNormal];
    self.likeButton.frame = CGRectMake(0.0, 0.0, likeImage.size.width / 2, likeImage.size.height / 2);
    commentButton.frame = CGRectMake(0.0, 0.0, commentImage.size.width / 2, commentImage.size.height / 2);
    shareButton.frame = CGRectMake(0.0, 0.0, shareImage.size.width / 2, shareImage.size.height / 2);
    [self.likeButton addTarget:self action:@selector(likeArticle) forControlEvents:UIControlEventTouchUpInside];
    [commentButton addTarget:self action:@selector(commentArticle) forControlEvents:UIControlEventTouchUpInside];
    [shareButton addTarget:self action:@selector(shareArticle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *likeBtn = [[UIBarButtonItem alloc] initWithCustomView:self.likeButton];
    UIBarButtonItem *commentBtn = [[UIBarButtonItem alloc] initWithCustomView:commentButton];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    // Spacer between buttons
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 20;
    
    int own_like = [[_articleData objectForKey:@"own_like"] integerValue];
    if (own_like)
        [self.likeButton setSelected:YES];
    else
        [self.likeButton setSelected:NO];
    
    self.navigationItem.rightBarButtonItems = @[shareBtn, fixedSpaceBarButtonItem, commentBtn, fixedSpaceBarButtonItem, likeBtn];
    
    self.viewContentArray = [[NSMutableArray alloc] init];
    self.viewContentHeights = [[NSMutableArray alloc] init];
    
    [self parseArticle];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)parseArticle {
    NSString *blogTitle = [_articleData objectForKey:@"blog_name"];
    NSString *articleName = [_articleData objectForKey:@"article_title"];
    NSString *photo = [_articleData objectForKey:@"article_photo"];
    NSString *profilePhoto = [_articleData objectForKey:@"user_photo"];
    NSString *articleContent = [_articleData objectForKey:@"article_content"];
    NSString *dateString = [_articleData objectForKey:@"article_created_at"];
    
    NSDateFormatter *inputFmt = [[NSDateFormatter alloc] init];
    NSDateFormatter *outputFmt = [[NSDateFormatter alloc] init];
    [inputFmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [outputFmt setDateFormat:@"d MMMM yyyy"];
    [outputFmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"]];
    NSDate *dateFromString = [inputFmt dateFromString:dateString];
    
    UIImageView *imageView;
    
    if (self.view.frame.size.width <= 320)
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 230)];
    else
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 315)];
    
    // Cover Photo Pre Loader
    CAGradientLayer *gradient = [CAGradientLayer layer];
    UIColor *blackGColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UIColor *whiteGColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    if (self.view.frame.size.width <= 320)
        gradient.frame = CGRectMake(0, 0, self.view.frame.size.width, 230);
    else
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
    if (photo != (id)[NSNull null]) {
        id path = photo;
        NSURL *imageUrl = [NSURL URLWithString:path];
        
        [self downloadImageWithURL:imageUrl completionBlock:^(BOOL succeeded, UIImage *img) {
            if (succeeded) {
                CGSize newSize;
                CGRect cropRect;
                
                float imgWidth = (img.size.width * 315) / img.size.height;
                newSize = CGSizeMake(imgWidth, 315);
                
                if (self.view.frame.size.width <= 320) {
                    imgWidth = (img.size.width * 230) / img.size.height;
                    newSize = CGSizeMake(imgWidth, 230);
                }
                
                float imgPos = (imgWidth - self.view.frame.size.width) / 2;
                
                self.shareImage = img;
                
                UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
                [img drawInRect:CGRectMake(0, -60, newSize.width, newSize.height)];
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                cropRect = CGRectMake(imgPos, 0, self.view.frame.size.width, 315);
                if (self.view.frame.size.width <= 320)
                    cropRect = CGRectMake(imgPos, 0, self.view.frame.size.width, 230);
                
                CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], cropRect);
                UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
                CGImageRelease(imageRef);
                
                UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:finalImage];
                [imageView addSubview:tmpImageView];
                
                if (photo.length)
                    [loader setHidden:YES];
            }
        }];
    } else {
        [imageView setImage:[UIImage imageNamed:@"default_article.jpg"]];
        self.shareImage = nil;
        [loader setHidden:YES];
    }
    
    // Profile Photo
    id path2 = profilePhoto;
    NSURL *profileImageUrl = [NSURL URLWithString:path2];
    NSData *profileImageData = [NSData dataWithContentsOfURL:profileImageUrl];
    UIImage *profileImg = [[UIImage alloc] initWithData:profileImageData];
    
    UIImageView *profileImageView;
    if (self.view.frame.size.width <= 320)
        profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(((self.view.frame.size.width / 2) - 35), 135, 70, 70)];
    else
        profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(((self.view.frame.size.width / 2) - 35), 220, 70, 70)];
    
    [profileImageView setImage:profileImg];
    
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBloggerProfile)];
    singleTap.numberOfTapsRequired = 1;
    profileImageView.userInteractionEnabled = YES;
    [profileImageView addGestureRecognizer:singleTap];
    
    // Article Date
    UILabel *articleDateLabel;
    
    if (self.view.frame.size.width <= 320)
        articleDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, self.view.frame.size.width, 30)];
    else
        articleDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 295, self.view.frame.size.width, 30)];
    
    [articleDateLabel setTextColor:[UIColor blackColor]];
    [articleDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    [articleDateLabel setTextAlignment:NSTextAlignmentCenter];
    articleDateLabel.text = [[outputFmt stringFromDate:dateFromString] uppercaseString];
    
    // Article Name
    UILabel *articleNameLabel;
    
    if (self.view.frame.size.width <= 320)
        articleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 235, self.view.frame.size.width - 20, 30)];
    else
        articleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 320, self.view.frame.size.width - 20, 30)];
    
    [articleNameLabel setTextColor:[UIColor blackColor]];
    [articleNameLabel setFont:[UIFont fontWithName:@"Apercu-Medium" size:23]];
    [articleNameLabel setTextAlignment:NSTextAlignmentCenter];
    articleNameLabel.text = [articleName uppercaseString];
    
    // Blog Title
    UILabel *blogTitleLabel;
    
    if (self.view.frame.size.width <= 320)
        blogTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 265, self.view.frame.size.width - 20, 25)];
    else
        blogTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 350, self.view.frame.size.width - 20, 25)];
    
    [blogTitleLabel setFont:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:14]];
    [blogTitleLabel setTextColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1]];
    [blogTitleLabel setTextAlignment:NSTextAlignmentCenter];
    blogTitleLabel.text = [@"Par " stringByAppendingString:blogTitle];
    
    UIView *articleContentView;
    if (self.view.frame.size.width <= 320)
        articleContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 200)];
    else
        articleContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 385, self.view.frame.size.width, 200)];
    
    NSMutableArray *substrings = [self stringByStrippingHTML:articleContent];
    self.totalHeight = 0;
    
    self.imgsToLoad = 0;
    self.imgsLoaded = 0;
    
    // Original Article Button
    UIImage *origArtBtn = [UIImage imageNamed:@"voirlebilletoriginal.png"];
    self.origArtButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.origArtButton setImage:origArtBtn forState:UIControlStateNormal];
    self.origArtButton.frame = CGRectMake((self.view.frame.size.width / 2) - (297 / 2), self.totalHeight, 297, 47);
    [self.origArtButton addTarget:self action:@selector(viewOrigArt) forControlEvents:UIControlEventTouchUpInside];
        
    if (self.view.frame.size.width <= 320)
        self.articleView.contentSize = CGSizeMake(self.view.frame.size.width, 367 + self.totalHeight);
    else
        self.articleView.contentSize = CGSizeMake(self.view.frame.size.width, 452 + self.totalHeight);
        
    [articleContentView addSubview:self.origArtButton];
    
    for (NSString *sub in substrings) {
        NSRange r;
        NSRange r2;
        
        if ((r = [sub rangeOfString:@"<img[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
            if ((r2 = [sub rangeOfString:@"src=(\"|')([^(\")|(')]*)(\"|')" options:NSRegularExpressionSearch]).location != NSNotFound) {
                NSInteger imgPos = self.viewContentArray.count;
                
                UIImageView *tmp = [[UIImageView alloc] init];
                [self.viewContentArray addObject:tmp];
                
                self.imgsToLoad++;
                
                NSString *source = [sub substringWithRange:r2];
                source = [source stringByReplacingOccurrencesOfString:@"src=\"" withString:@""];
                source = [source stringByReplacingOccurrencesOfString:@"src='" withString:@""];
                source = [source stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                source = [source stringByReplacingOccurrencesOfString:@"'" withString:@""];
                    
                id path3 = source;
                NSURL *articleImgUrl = [NSURL URLWithString:path3];
                    
                NSURLRequest *request = [NSURLRequest requestWithURL:articleImgUrl];
                
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *articleImg = [[UIImage alloc] initWithData:data];
                        
                        if (articleImg.size.width >= 200) {
                            float oldWidth = articleImg.size.width;
                            float scaleFactor = self.view.frame.size.width / oldWidth;
                            float newHeight = articleImg.size.height * scaleFactor;
                            float newWidth = oldWidth * scaleFactor;
                            
                            UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
                            [articleImg drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
                            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                            UIGraphicsEndImageContext();
                            
                            UIImageView *articleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.totalHeight + 10, self.view.frame.size.width, newImage.size.height)];
                            [articleImgView setImage:newImage];
                            
                            self.totalHeight += (newImage.size.height + 20);
                            
                            CGRect frame = self.view.frame;
                            frame.size = CGSizeMake(self.view.frame.size.width, self.totalHeight);
                            self.view.frame = frame;
                            
                            self.articleView.contentSize = CGSizeMake(self.view.frame.size.width, 385 + self.totalHeight);
                            
                            [self.viewContentArray[imgPos] removeFromSuperview];
                            self.viewContentArray[imgPos] = articleImgView;
                            [self updateElementPosition];
                            [articleContentView addSubview:self.viewContentArray[imgPos]];
                        } else
                            [self.viewContentArray[imgPos] removeFromSuperview];
                    } else
                        [self.viewContentArray[imgPos] removeFromSuperview];
                    
                    self.imgsLoaded++;
                }];
            }
        } else {
            if (sub.length) {
                UITextView *contentLabel = [[UITextView alloc] initWithFrame:CGRectMake(10, self.totalHeight, self.view.frame.size.width - 20, 100)];
                [contentLabel setDelegate:self];
                [contentLabel setEditable:NO];
                [contentLabel setSelectable:NO];
                [contentLabel setScrollEnabled:NO];
                
                NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
                paragrahStyle.lineSpacing = 7;
                if (self.view.frame.size.width <= 320)
                    paragrahStyle.lineSpacing = 6;
                paragrahStyle.alignment = NSTextAlignmentLeft;
                NSDictionary *attrsDictionary = @{
                                                  NSParagraphStyleAttributeName: paragrahStyle,
                                                  NSFontAttributeName: [UIFont fontWithName:@"Georgia" size:16],
                                                  };
                contentLabel.attributedText = [[NSAttributedString alloc] initWithString:sub attributes:attrsDictionary];
                [contentLabel setTextColor:[UIColor colorWithRed:0.26f green:0.26f blue:0.26f alpha:1]];
                
                CGSize contentSize = [contentLabel sizeThatFits:CGSizeMake(self.view.frame.size.width - 20, 100000)];
                CGRect frame = contentLabel.frame;
                frame.size = CGSizeMake(contentSize.width, contentSize.height);
                contentLabel.frame = frame;
                self.totalHeight += frame.size.height + 10;
                
                [self.viewContentArray addObject:contentLabel];
                [self updateElementPosition];
            }
        }
    }
    
    if (self.view.frame.size.width <= 320)
        self.totalHeight -= 20;
    else
        self.totalHeight += 67;
    
    for (UIView *v in self.viewContentArray)
        [articleContentView addSubview:v];
    
    CGRect frame = articleContentView.frame;
    frame.size.height = self.totalHeight;
    articleContentView.frame = frame;
    
    // Set the Article View
    self.articleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60)];
    [self.articleView setScrollEnabled:YES];
    
    self.articleView.contentSize = CGSizeMake(self.view.frame.size.width, 385 + self.totalHeight);
    
    [self.articleView addSubview:imageView];
    [self.articleView addSubview:profileImageView];
    [self.articleView addSubview:articleDateLabel];
    [self.articleView addSubview:articleNameLabel];
    [self.articleView addSubview:blogTitleLabel];
    [self.articleView addSubview:articleContentView];
    
    for (UIView *view in [self.view subviews])
        [view removeFromSuperview];
    
    [self.view addSubview:self.articleView];
}

- (void)updateElementPosition {
    float tHeight = 0;
    
    for (int i = 0; i < self.viewContentArray.count; i++) {
        UIView * v = self.viewContentArray[i];
        
        if (v.frame.size.height != 0) {
            v.frame = CGRectMake(v.frame.origin.x, tHeight, v.frame.size.width, v.frame.size.height);
            
            tHeight += v.frame.size.height + 10;
        }
    }
    
    self.origArtButton.frame = CGRectMake((self.view.frame.size.width / 2) - (297 / 2), tHeight, 297, 47);
    
    if (self.view.frame.size.width <= 320)
        self.articleView.contentSize = CGSizeMake(self.view.frame.size.width, 367 + tHeight);
    else
        self.articleView.contentSize = CGSizeMake(self.view.frame.size.width, 452 + tHeight);
}

- (void)textViewDidChange:(UITextView *)textView {

}

- (NSMutableArray *)stringByStrippingHTML:(NSString *)s {
    NSRange r;
    
    while ((r = [s rangeOfString:@"<(?!img)[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    
    
    NSMutableArray *substrings = [[NSMutableArray alloc] init];
    while ((r = [s rangeOfString:@"<img[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        if (r.location > 0) {
            NSRange range1 = NSMakeRange(0, r.location - 1);
            
            [substrings addObject:[s substringWithRange:range1]];
        }
        
        [substrings addObject:[s substringWithRange:r]];
        
        NSRange range2 = NSMakeRange(r.location + r.length, [s length] - (r.location + r.length + 1));
        s = [s substringWithRange:range2];
    }
    
    return substrings;
}

- (void)viewOrigArt {
    NSString *articleUrl = [_articleData objectForKey:@"article_url"];
    NSURL *url = [NSURL URLWithString:articleUrl];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (void)viewBloggerProfile {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BloggerProfileViewController *viewController = (BloggerProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BloggerProfileViewController"];
    
    viewController.articleData = _articleData;
    viewController.hvc = self.hvc;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)likeArticle {
    int likes = [[_articleData objectForKey:@"article_likes"] intValue];
    int own_like = [[_articleData objectForKey:@"own_like"] intValue];
    
    own_like = !own_like;
    
    NSString *sUrl;
    User *user = [User getInstance];
    
    if (self.likeButton.selected) {
        likes = likes - 1;
        sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/unlikeArticle?id=%@&user=%ld", [_articleData objectForKey:@"article_id"], (long)user.userId];
    } else {
        likes = likes + 1;
        sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/likeArticle?id=%@&user=%ld", [_articleData objectForKey:@"article_id"], (long)user.userId];
    }
    
    [self.likeButton setSelected:![self.likeButton isSelected]];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    [_articleData setValue:[NSString stringWithFormat:@"%d", likes] forKey:@"article_likes"];
    [_articleData setValue:[NSString stringWithFormat:@"%d", own_like] forKey:@"own_like"];
}

- (void)commentArticle {
    CommentsViewController *viewController = [[CommentsViewController alloc] init];
    
    viewController.responseData = _responseData;
    viewController.userData = _userData;
    viewController.articleData = _articleData;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)shareArticle {
    NSString *message = [_articleData objectForKey:@"article_title"];
    NSURL *sharingUrl = [NSURL URLWithString:[_articleData objectForKey:@"article_url"]];
    
    NSArray *sharingItems;
    
    if (self.shareImage == nil)
        sharingItems = @[message, sharingUrl];
    else
        sharingItems = @[message, sharingUrl, self.shareImage];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

@end
