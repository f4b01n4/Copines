//
//  BloggerProfileViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 18/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "User.h"
#import "BloggerProfileViewController.h"
#import "BloggerFeedViewController.h"
#import "Localization.h"

@interface BloggerProfileViewController ()

@end

@implementation BloggerProfileViewController

@synthesize articleData = _articleData;

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
    
    self.theStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Set custom left bar button
    UIImage *buttonImage = [UIImage imageNamed:@"close.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width / 2, buttonImage.size.height / 2);
    [aButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    
    // Set custom right bar button
    UIImage *likeImage1 = [UIImage imageNamed:@"follow1.png"];
    UIImage *likeImage2 = [UIImage imageNamed:@"follow2.png"];
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton setImage:likeImage1 forState:UIControlStateNormal];
    [self.likeButton setImage:likeImage2 forState:UIControlStateSelected];
    self.likeButton.frame = CGRectMake(0.0, 0.0, likeImage2.size.width / 2, likeImage2.size.height / 2);
    [self.likeButton addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.likeButton];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    int own_blog_like = [[_articleData objectForKey:@"own_blog_like"] integerValue];
    
    if (own_blog_like)
        [self.likeButton setSelected:YES];
    else
        [self.likeButton setSelected:NO];
    
    // Set transparent bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [_titleLabel setFont:[UIFont fontWithName:@"Apercu-Bold" size:24.0f]];
    [_url setFont:[UIFont fontWithName:@"Apercu-Light" size:16.0f]];
    [_location setFont:[UIFont fontWithName:@"Apercu-Light" size:16.0f]];
    [_bio setFont:[UIFont fontWithName:@"Apercu" size:16.0f]];
    [_bio setEditable:FALSE];
    [_bio setSelectable:FALSE];
    [_articlesLabel setFont:[UIFont fontWithName:@"Apercu-Bold" size:18.0f]];
    [_articles setFont:[UIFont fontWithName:@"Apercu" size:16.0f]];
    [_followersLabel setFont:[UIFont fontWithName:@"Apercu-Bold" size:18.0f]];
    [_followers setFont:[UIFont fontWithName:@"Apercu" size:16.0f]];
    [_followingLabel setFont:[UIFont fontWithName:@"Apercu-Bold" size:18.0f]];
    [_following setFont:[UIFont fontWithName:@"Apercu" size:16.0f]];
    [_bio setBackgroundColor:[UIColor clearColor]];
    
    _titleLabel.text = [_articleData objectForKey:@"blog_name"];
    _url.text = [_articleData objectForKey:@"blog_url"];
    _location.text = [NSString stringWithFormat:@"%@, %@", [_articleData objectForKey:@"user_city"], [_articleData objectForKey:@"user_country"]];
    if ([_articleData objectForKey:@"blog_description"] != (id)[NSNull null])
        _bio.text = [_articleData objectForKey:@"blog_description"];
    _articlesLabel.text = [_articleData objectForKey:@"blog_articles"];
    _followersLabel.text = [_articleData objectForKey:@"blog_followers"];
    _followingLabel.text = [_articleData objectForKey:@"user_following"];
    
    NSString *photo = [_articleData objectForKey:@"user_photo"];
    NSString *background = [_articleData objectForKey:@"blog_background_image"];
    
    if (photo != (id)[NSNull null]) {
        id path = photo;
        NSURL *profileImageUrl = [NSURL URLWithString:path];
        NSData *profileImageData = [NSData dataWithContentsOfURL:profileImageUrl];
        UIImage *profileImg = [[UIImage alloc] initWithData:profileImageData];
        [_profilePhoto setImage:profileImg];
        
        _profilePhoto.clipsToBounds = YES;
        _profilePhoto.layer.cornerRadius = _profilePhoto.frame.size.width / 2;
    }
    
    if (background != (id)[NSNull null]) {
        id cover_path = background;
        NSURL *coverImageUrl = [NSURL URLWithString:cover_path];
        NSData *coverImageData = [NSData dataWithContentsOfURL:coverImageUrl];
        UIImage *coverImg = [[UIImage alloc] initWithData:coverImageData];
        [_coverPhoto setImage:coverImg];
    }
}

- (void)viewDidLayoutSubviews {
    if (self.view.frame.size.width == 320) {
        [self.bio setFrame:CGRectMake(self.bio.frame.origin.x, self.bio.frame.origin.y, self.bio.frame.size.width, self.bio.frame.size.height - 20)];
        [self.articles setFrame:CGRectMake(self.articles.frame.origin.x, self.articles.frame.origin.y - 20, self.articles.frame.size.width, self.articles.frame.size.height)];
        [self.followers setFrame:CGRectMake(self.followers.frame.origin.x, self.followers.frame.origin.y - 20, self.followers.frame.size.width, self.followers.frame.size.height)];
        [self.following setFrame:CGRectMake(self.following.frame.origin.x, self.following.frame.origin.y - 20, self.following.frame.size.width, self.following.frame.size.height)];
        [self.articlesLabel setFrame:CGRectMake(self.articlesLabel.frame.origin.x, self.articlesLabel.frame.origin.y - 20, self.articlesLabel.frame.size.width, self.articlesLabel.frame.size.height)];
        [self.followersLabel setFrame:CGRectMake(self.followersLabel.frame.origin.x, self.followersLabel.frame.origin.y - 20, self.followersLabel.frame.size.width, self.followersLabel.frame.size.height)];
        [self.followingLabel setFrame:CGRectMake(self.followingLabel.frame.origin.x, self.followingLabel.frame.origin.y - 20, self.followingLabel.frame.size.width, self.followingLabel.frame.size.height)];
        [self.viewArticlesBtn setFrame:CGRectMake(self.viewArticlesBtn.frame.origin.x, self.viewArticlesBtn.frame.origin.y - 25, self.viewArticlesBtn.frame.size.width, self.viewArticlesBtn.frame.size.height)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) popBack {
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)like {
    int likes = [[_articleData objectForKey:@"blog_likes"] intValue];
    int own_blog_like = [[_articleData objectForKey:@"own_blog_like"] intValue];
    
    own_blog_like = !own_blog_like;
    
    NSString *sUrl;
    User *user = [User getInstance];
    
    if (self.likeButton.selected) {
        likes = likes - 1;
        sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/unlikeBlog?id=%@&user=%ld", [_articleData objectForKey:@"blog_id"], (long)user.userId];
    } else {
        likes = likes + 1;
        sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/likeBlog?id=%@&user=%ld", [_articleData objectForKey:@"blog_id"], (long)user.userId];
    }
    
    [self.likeButton setSelected:![self.likeButton isSelected]];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    [_articleData setValue:[NSString stringWithFormat:@"%d", likes] forKey:@"blog_likes"];
    [_articleData setValue:[NSString stringWithFormat:@"%d", own_blog_like] forKey:@"own_blog_like"];
}

- (IBAction)bloggerFeed:(id)sender {
    BloggerFeedViewController *bf = [self.theStoryboard instantiateViewControllerWithIdentifier:@"three"];
    bf.blogId = [[_articleData objectForKey:@"blog_id"] integerValue];
    bf.blogTitle = [_articleData objectForKey:@"blog_name"];
    
    [self.navigationController pushViewController:bf animated:YES];
}
@end
