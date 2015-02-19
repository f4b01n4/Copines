//
//  CommentsViewController.h
//  Revue de Copines
//
//  Created by Fábio Violante on 18/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSDictionary *responseData;
@property (strong, nonatomic) NSArray *userData;
@property (strong, nonatomic) NSDictionary *articleData;
@property (strong, nonatomic) UITextField *commentField;
@property (strong, nonatomic) UIScrollView *commentsView;
@property (nonatomic) float placeholder;

@end