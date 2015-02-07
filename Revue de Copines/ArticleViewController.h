//
//  ArticleViewController.h
//  Revue de Copines
//
//  Created by Fábio Violante on 17/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) NSDictionary *responseData;
@property (strong, nonatomic) NSArray *userData;
@property (strong, nonatomic) NSDictionary *articleData;
@property (strong, nonatomic) UIView *loadingView;
@property (nonatomic) float totalHeight;
@property (strong, nonatomic) UIScrollView *articleView;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UIImage *shareImage;

@property (strong, nonatomic) NSMutableArray *viewContentArray;
@property (strong, nonatomic) NSMutableArray *viewContentHeights;

@property (strong, nonatomic) UIButton *origArtButton;

@property (nonatomic) int imgsToLoad;
@property (nonatomic) int imgsLoaded;
@property (nonatomic) BOOL loadingImg;

@end
