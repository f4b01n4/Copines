//
//  BloggerProfileViewController.h
//  Revue de Copines
//
//  Created by Fábio Violante on 18/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;

@interface BloggerProfileViewController : UIViewController

@property (strong, nonatomic) HomeViewController *hvc;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) NSDictionary *articleData;
@property (strong, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (strong, nonatomic) UIStoryboard *theStoryboard;
@property (weak, nonatomic) IBOutlet UILabel *url;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UITextView *bio;
@property (weak, nonatomic) IBOutlet UILabel *articlesLabel;
@property (weak, nonatomic) IBOutlet UILabel *articles;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverPhoto;
@property (weak, nonatomic) IBOutlet UIButton *viewArticlesBtn;
@property (nonatomic) BOOL needToRefresh;

- (IBAction)bloggerFeed:(id)sender;

@end