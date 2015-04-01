//
//  ImageViewController.h
//  Copines
//
//  Created by Fábio Violante on 18/03/15.
//  Copyright (c) 2015 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *imagePath;

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

- (IBAction)BackBtnPress:(id)sender;

@end
