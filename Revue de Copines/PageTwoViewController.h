//
//  PageTwoViewController.h
//  Revue de Copines
//
//  Created by Fábio Violante on 14/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleViewController;
@class BloggerProfileViewController;

@interface PageTwoViewController : UIViewController <UIScrollViewDelegate> {
    BOOL isDragging;
    CGPoint cInitialLocation;
    CGPoint pInitialLocation;
    CGPoint nInitialLocation;
    CGPoint firstTouch;
    CGPoint currentTouch;
}

@property (strong, nonatomic) ArticleViewController *articleViewController;
@property (strong, nonatomic) BloggerProfileViewController *bloggerProfileViewController;
@property (strong, nonatomic) HomeViewController *hvc;
@property (strong, nonatomic) NSDictionary *responseData;
@property (strong, nonatomic) NSArray *userData;
@property (strong, nonatomic) NSArray *articlesData;
@property (nonatomic) int totalArticles;
@property (nonatomic) int currentArticle;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UILabel *likesLabel;
@property (strong, nonatomic) UINavigationItem *navItem;
@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UITextView *articleContentView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic) int lastLoadedArticle;
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic) NSInteger previousPage;

@property (strong, nonatomic) UIView *prevArticle;
@property (strong, nonatomic) UIView *currArticle;
@property (strong, nonatomic) UIView *nextArticle;

-(void)setScrollEnabled:(BOOL)enabled;
-(void)likeArticle;
-(void)commentArticle;
-(void)scrollToTop;

@end