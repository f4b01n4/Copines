//
//  Subscription4ViewController.h
//  Revue de Copines
//
//  Created by Fábio Violante on 14/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;

@interface Subscription4ViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UIImageView *coverPhoto;
@property (weak, nonatomic) IBOutlet UILabel *profilePhotoLabel;
@property (weak, nonatomic) IBOutlet UILabel *coverPhotoLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *localisationLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *localisationInput;
@property (weak, nonatomic) IBOutlet UITextField *blogInput;
@property (weak, nonatomic) IBOutlet UITextView *bioInput;
@property (weak, nonatomic) IBOutlet UIButton *modeBtn;
@property (weak, nonatomic) IBOutlet UIButton *beauteBtn;
@property (weak, nonatomic) IBOutlet UIButton *diyBtn;
@property (weak, nonatomic) IBOutlet UIButton *foodBtn;
@property (weak, nonatomic) IBOutlet UIButton *voyagesBtn;
@property (weak, nonatomic) IBOutlet UIButton *fitnessBtn;
@property (weak, nonatomic) IBOutlet UIButton *decorationBtn;
@property (weak, nonatomic) IBOutlet UIButton *famileBtn;
@property (weak, nonatomic) IBOutlet UIButton *mariageBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *twitterBtn;
@property (weak, nonatomic) IBOutlet UIButton *instagramBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinterestBtn;
@property (weak, nonatomic) IBOutlet UIButton *googleBtn;
- (IBAction)modeBtnPressed:(id)sender;
- (IBAction)beauteBtnPressed:(id)sender;
- (IBAction)diyBtnPressed:(id)sender;
- (IBAction)foodBtnPressed:(id)sender;
- (IBAction)voyagesBtnPressed:(id)sender;
- (IBAction)fitnessBtnPressed:(id)sender;
- (IBAction)decorationBtnPressed:(id)sender;
- (IBAction)famileBtnPressed:(id)sender;
- (IBAction)mariageBtnPressed:(id)sender;
- (IBAction)facebookBtnPressed:(id)sender;
- (IBAction)twitterBtnPressed:(id)sender;
- (IBAction)instagramBtnPressed:(id)sender;
- (IBAction)pinterestBtnPressed:(id)sender;
- (IBAction)googleBtnPressed:(id)sender;

-(void) popBack;

@property (strong, nonatomic) UIBarButtonItem *registerItem;
@property (strong, nonatomic) UIBarButtonItem *backItem;

@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) int nSelected;
@property (nonatomic) int cat1;
@property (nonatomic) int cat2;
@property (nonatomic) int cat3;

@property (strong, nonatomic) NSString *facebookUrl;
@property (strong, nonatomic) NSString *twitterUrl;
@property (strong, nonatomic) NSString *instagramUrl;
@property (strong, nonatomic) NSString *pinterestUrl;
@property (strong, nonatomic) NSString *googleUrl;

@end
