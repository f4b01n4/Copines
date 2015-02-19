//
//  ManageProfileViewController.h
//  Revue de Copines
//
//  Created by Fábio Violante on 16/02/15.
//  Copyright (c) 2015 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageProfileViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UILabel *profilePhotoLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *password2Label;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UITextField *password2Input;

@end