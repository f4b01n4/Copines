//
//  HomeViewController.h
//  Revue de Copines
//
//  Created by Fábio Violante on 14/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class PageOneViewController;
@class PageScrollViewController;
@class PageViewController;
@class BloggerFeedViewController;

@interface HomeViewController : UIPageViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIStoryboard *theStoryboard;
@property (strong, nonatomic) UIView *menu;
@property (strong, nonatomic) UIView *menuSwipeView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UIButton *commentsButton;
@property (strong, nonatomic) UILabel *likesLabel;
@property (strong, nonatomic) UILabel *commentsLabel;
@property (strong, nonatomic) UIImageView *nArticlesImageView;
@property (strong, nonatomic) UILabel *nArticlesLabel;

@property (nonatomic) BOOL menuVisible;
@property (strong, nonatomic) NSMutableArray *pages;
@property (nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) PageOneViewController *mainPageViewController;
@property (strong, nonatomic) PageViewController *pageOneViewController;
@property (strong, nonatomic) PageViewController *pageTwoViewController;
@property (strong, nonatomic) PageViewController *pageThreeViewController;
@property (strong, nonatomic) PageViewController *pageFourViewController;
@property (strong, nonatomic) PageViewController *pageFiveViewController;
@property (strong, nonatomic) PageViewController *pageSixViewController;
@property (strong, nonatomic) PageViewController *pageSevenViewController;
@property (strong, nonatomic) PageViewController *pageEightViewController;
@property (strong, nonatomic) PageViewController *pageNineViewController;
@property (strong, nonatomic) PageScrollViewController *pageScrollViewController;
@property (strong, nonatomic) BloggerFeedViewController *bloggerFeedViewController;

@property (strong, nonatomic) NSDictionary *copinesData;
@property (strong, nonatomic) NSMutableArray *articlesData;
@property (nonatomic, strong) NSMutableArray *currentArticle;
@property (nonatomic, strong) NSMutableArray *lastUpdate;

-(void)setScrollEnabled:(BOOL)enabled;
-(void)drawTitle:(NSInteger)page;
-(void)hideNArticlesButton;
-(void)reinitCategoriesLoading;
-(void)reinitCategories;

@end
