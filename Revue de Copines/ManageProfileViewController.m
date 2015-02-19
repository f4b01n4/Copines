//
//  ManageProfileViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 16/02/15.
//  Copyright (c) 2015 Pears & Bragston. All rights reserved.
//

#import "ManageProfileViewController.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "Localization.h"

@interface ManageProfileViewController ()

@end

@implementation ManageProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hide Back Button
    self.navigationItem.hidesBackButton = YES;
    
    // Set Right Bar Button Item
    self.backItem = [[UIBarButtonItem alloc] initWithTitle:@"Terminé" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.backItem.tintColor = [UIColor whiteColor];
    [self.backItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Apercu" size:16]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = self.backItem;
    
    // Set Title
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    navTitle.text = @"Gérer mon profil";
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [navTitle setFont:[UIFont fontWithName:@"Apercu-Bold" size:20]];
    self.navigationItem.titleView = navTitle;
    
    [_profilePhotoLabel setFont:[UIFont fontWithName:@"Apercu-Medium" size:14.0f]];
    [_nameLabel setFont:[UIFont fontWithName:@"Apercu-Medium" size:14.0f]];
    [_emailLabel setFont:[UIFont fontWithName:@"Apercu-Medium" size:14.0f]];
    [_passwordLabel setFont:[UIFont fontWithName:@"Apercu-Medium" size:14.0f]];
    [_password2Label setFont:[UIFont fontWithName:@"Apercu-Medium" size:14.0f]];
    [_nameInput setFont:[UIFont fontWithName:@"Apercu-Light" size:14.0f]];
    [_emailInput setFont:[UIFont fontWithName:@"Apercu-Light" size:14.0f]];
    [_passwordInput setFont:[UIFont fontWithName:@"Apercu-Light" size:14.0f]];
    [_password2Input setFont:[UIFont fontWithName:@"Apercu-Light" size:14.0f]];
    
    User *user = [User getInstance];
    
    [_nameInput setText:user.name];
    [_emailInput setText:user.email];
    
    UITapGestureRecognizer *profilePhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectProfilePhoto)];
    profilePhotoTap.numberOfTapsRequired = 1;
    self.profilePhoto.userInteractionEnabled = YES;
    self.profilePhoto.clipsToBounds = YES;
    
    [self.profilePhoto addGestureRecognizer:profilePhotoTap];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) popBack {
    Localization *localization = [[Localization alloc] init];
    
    NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/checkConnection"] encoding:NSUTF8StringEncoding error:nil];
    
    if (![connect isEqualToString:@"success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"no internet connection" forLocale:@"fr"] message:[localization getStringForText:@"you must be connected to the internet" forLocale:@"fr"] delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
        
        [alert show];
    } else {
        User *user = [User getInstance];
        
        user.name = self.nameInput.text;
        user.password = self.passwordInput.text;
        
        if ([user validate]) {
            if ([self.passwordInput.text isEqualToString:self.password2Input.text] == NO) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"password mismatch" forLocale:@"fr"] message:[localization getStringForText:@"the passwords don't match" forLocale:@"fr"] delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
                
                [alert show];
            } else {
                NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
                [_params setObject:[NSString stringWithFormat:@"%ld", (long)user.userId] forKey:@"user_id"];
                [_params setObject:self.nameInput.text forKey:@"user_name"];
                [_params setObject:self.passwordInput.text forKey:@"user_password"];
                
                NSData *profileImageData = UIImageJPEGRepresentation(self.profilePhoto.image, 100);
                
                NSString *urlString = @"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/updateUser/";
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:[NSURL URLWithString:urlString]];
                [request setHTTPMethod:@"POST"];
                
                NSMutableData *body = [NSMutableData data];
                NSString *boundary = @"---------------------------14737809831466499882746641449";
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
                [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
                
                /* PROFILE IMAGE */
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profile\"; filename=\"%@.jpg\"\r\n",@"profileImage"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:profileImageData]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                /* DEFAULT PARAMS */
                for (NSString *param in _params) {
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
                }
                
                /* CLOSE FORM-DATA */
                [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [request setHTTPBody:body];
                
                
                [self.backItem setEnabled:FALSE];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = [localization getStringForText:@"creating account" forLocale:@"fr"];
                hud.detailsLabelText = [localization getStringForText:@"please wait" forLocale:@"fr"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.backItem setEnabled:TRUE];
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        self.navigationController.navigationBar.translucent = YES;
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                });
            }
        }
    }
}

- (void)selectProfilePhoto {
    Localization *localization = [[Localization alloc] init];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[localization getStringForText:@"what do you want to do" forLocale:@"fr"]
                                                             delegate:self cancelButtonTitle:[localization getStringForText:@"cancel" forLocale:@"fr"] destructiveButtonTitle:nil otherButtonTitles:[localization getStringForText:@"take photo" forLocale:@"fr"], [localization getStringForText:@"select from library" forLocale:@"fr"], nil];
    
    [actionSheet showInView:self.view];
    actionSheet.tag = 100;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
        
    if (buttonIndex == 0)
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    else if (buttonIndex == 1)
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (buttonIndex == 0 || buttonIndex == 1)
        [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.profilePhoto.image = chosenImage;
    self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.width / 2;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField; {
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    
    if (nextResponder && nextTag != 3) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self animateTextField: textField up: NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self animateTextView: textView up: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self animateTextView: textView up: NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        
        return NO;
    } else
        return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up {
    if (textField.tag == 3) {
        const int movementDistance = 150;
        const float movementDuration = 0.3f;
        
        int movement = (up ? -movementDistance : movementDistance);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

- (void) animateTextView: (UITextView*) textView up: (BOOL) up {
    const int movementDistance = 200;
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
