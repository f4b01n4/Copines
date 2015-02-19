//
//  ManageBlogViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 18/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "ManageBlogViewController.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "Localization.h"

@interface ManageBlogViewController ()

@end

@implementation ManageBlogViewController

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
    navTitle.text = @"Gérer mon blog";
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [navTitle setFont:[UIFont fontWithName:@"Apercu-Bold" size:20]];
    self.navigationItem.titleView = navTitle;
    
    [_profilePhotoLabel setFont:[UIFont fontWithName:@"Apercu-Medium" size:14.0f]];
    [_coverPhotoLabel setFont:[UIFont fontWithName:@"Apercu-Medium" size:14.0f]];
    [_nameLabel setFont:[UIFont fontWithName:@"Apercu-Medium" size:14.0f]];
    [_localisationLabel setFont:[UIFont fontWithName:@"Apercu-Medium" size:14.0f]];
    [_blogLabel setFont:[UIFont fontWithName:@"Apercu-Medium" size:14.0f]];
    [_categoryLabel setFont:[UIFont fontWithName:@"Apercu-Medium" size:14.0f]];
    [_bioLabel setFont:[UIFont fontWithName:@"Apercu-MediumItalic" size:14.0f]];
    [_socialLabel setFont:[UIFont fontWithName:@"Apercu-MediumItalic" size:14.0f]];
    [_nameInput setFont:[UIFont fontWithName:@"Apercu-Light" size:14.0f]];
    [_localisationInput setFont:[UIFont fontWithName:@"Apercu-Light" size:14.0f]];
    [_blogInput setFont:[UIFont fontWithName:@"Apercu-Light" size:14.0f]];
    [_bioInput setFont:[UIFont fontWithName:@"Apercu-Light" size:14.0f]];
    
    User *user = [User getInstance];
    
    [_nameInput setText:user.blog_name];
    [_localisationInput setText:user.blog_localisation];
    [_blogInput setText:user.blog_url];
    [_bioInput setText:user.blog_description];
    
    NSArray *btns = [[NSArray alloc] initWithObjects:
                     _modeBtn, _beauteBtn, _diyBtn,
                     _voyagesBtn, _decorationBtn, _fitnessBtn,
                     _foodBtn, _mariageBtn, _famileBtn, nil];
    
    UIButton *btn1 = btns[user.blog_cat1 - 1];
    UIButton *btn2 = btns[user.blog_cat2 - 1];
    UIButton *btn3 = btns[user.blog_cat3 - 1];
    
    [btn1 setSelected:YES];
    [btn2 setSelected:YES];
    [btn3 setSelected:YES];
    
    self.nSelected = 3;
    
    UITapGestureRecognizer *profilePhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectProfilePhoto)];
    UITapGestureRecognizer *coverPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCoverPhoto)];
    profilePhotoTap.numberOfTapsRequired = 1;
    coverPhotoTap.numberOfTapsRequired = 1;
    self.profilePhoto.userInteractionEnabled = YES;
    self.coverPhoto.userInteractionEnabled = YES;
    self.profilePhoto.clipsToBounds = YES;
    self.coverPhoto.clipsToBounds = YES;
    
    [self.profilePhoto addGestureRecognizer:profilePhotoTap];
    [self.coverPhoto addGestureRecognizer:coverPhotoTap];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLayoutSubviews {
    
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
        if (![self getSelectedCategories])
            return;
        
        NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
        [_params setObject:[NSString stringWithFormat:@"%ld", (long)user.userId] forKey:@"user_id"];
        [_params setObject:self.nameInput.text forKey:@"blog_name"];
        [_params setObject:self.localisationInput.text forKey:@"blog_localisation"];
        [_params setObject:self.blogInput.text forKey:@"blog_url"];
        [_params setObject:[NSString stringWithFormat:@"%d", self.cat1] forKey:@"blog_cat1"];
        [_params setObject:[NSString stringWithFormat:@"%d", self.cat2] forKey:@"blog_cat2"];
        [_params setObject:[NSString stringWithFormat:@"%d", self.cat3] forKey:@"blog_cat3"];
        [_params setObject:self.bioInput.text forKey:@"blog_description"];
        
        NSData *profileImageData = UIImageJPEGRepresentation(self.profilePhoto.image, 100);
        NSData *coverImageData = UIImageJPEGRepresentation(self.coverPhoto.image, 100);
        
        NSString *urlString = @"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/updateBlogger/";
        
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
        
        /* COVER IMAGE */
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"cover\"; filename=\"%@.jpg\"\r\n",@"coverImage"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:coverImageData]];
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

- (void)selectProfilePhoto {
    Localization *localization = [[Localization alloc] init];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[localization getStringForText:@"what do you want to do" forLocale:@"fr"]
                                                             delegate:self cancelButtonTitle:[localization getStringForText:@"cancel" forLocale:@"fr"] destructiveButtonTitle:nil otherButtonTitles:[localization getStringForText:@"take photo" forLocale:@"fr"], [localization getStringForText:@"select from library" forLocale:@"fr"], nil];
    
    [actionSheet showInView:self.view];
    actionSheet.tag = 100;
}

- (void)selectCoverPhoto {
    Localization *localization = [[Localization alloc] init];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[localization getStringForText:@"what do you want to do" forLocale:@"fr"]
                                                             delegate:self cancelButtonTitle:[localization getStringForText:@"cancel" forLocale:@"fr"] destructiveButtonTitle:nil otherButtonTitles:[localization getStringForText:@"take photo" forLocale:@"fr"], [localization getStringForText:@"select from library" forLocale:@"fr"], nil];
    
    [actionSheet showInView:self.view];
    actionSheet.tag = 200;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if (actionSheet.tag == 100) {
        picker.view.tag = 1;
        
        if (buttonIndex == 0)
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        else if (buttonIndex == 1)
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (actionSheet.tag == 200) {
        picker.view.tag = 2;
        
        if (buttonIndex == 0)
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        else if (buttonIndex == 1)
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    if (buttonIndex == 0 || buttonIndex == 1)
        [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    if (picker.view.tag == 1) {
        self.profilePhoto.image = chosenImage;
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.width / 2;
    } else if (picker.view.tag == 2) {
        self.coverPhoto.image = chosenImage;
        self.coverPhoto.layer.cornerRadius = self.coverPhoto.frame.size.width / 10;
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)modeBtnPressed:(id)sender {
    _modeBtn.selected = !_modeBtn.selected;
    
    if (_modeBtn.selected == YES)
        self.nSelected++;
    else
        self.nSelected--;
}

- (IBAction)beauteBtnPressed:(id)sender {
    _beauteBtn.selected = !_beauteBtn.selected;
    
    if (_beauteBtn.selected == YES)
        self.nSelected++;
    else
        self.nSelected--;
}

- (IBAction)diyBtnPressed:(id)sender {
    _diyBtn.selected = !_diyBtn.selected;
    
    if (_diyBtn.selected == YES)
        self.nSelected++;
    else
        self.nSelected--;
}

- (IBAction)foodBtnPressed:(id)sender {
    _foodBtn.selected = !_foodBtn.selected;
    
    if (_foodBtn.selected == YES)
        self.nSelected++;
    else
        self.nSelected--;
}

- (IBAction)voyagesBtnPressed:(id)sender {
    _voyagesBtn.selected = !_voyagesBtn.selected;
    
    if (_voyagesBtn.selected == YES)
        self.nSelected++;
    else
        self.nSelected--;
}

- (IBAction)fitnessBtnPressed:(id)sender {
    _fitnessBtn.selected = !_fitnessBtn.selected;
    
    if (_fitnessBtn.selected == YES)
        self.nSelected++;
    else
        self.nSelected--;
}

- (IBAction)decorationBtnPressed:(id)sender {
    _decorationBtn.selected = !_decorationBtn.selected;
    
    if (_decorationBtn.selected == YES)
        self.nSelected++;
    else
        self.nSelected--;
}

- (IBAction)famileBtnPressed:(id)sender {
    _famileBtn.selected = !_famileBtn.selected;
    
    if (_famileBtn.selected == YES)
        self.nSelected++;
    else
        self.nSelected--;
}

- (IBAction)mariageBtnPressed:(id)sender {
    _mariageBtn.selected = !_mariageBtn.selected;
    
    if (_mariageBtn.selected == YES)
        self.nSelected++;
    else
        self.nSelected--;
}

- (IBAction)facebookBtnPressed:(id)sender {
    Localization *localization = [[Localization alloc] init];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:[localization getStringForText:@"please type your facebook profile url" forLocale:@"fr"] delegate:self cancelButtonTitle:[localization getStringForText:@"cancel" forLocale:@"fr"] otherButtonTitles:[localization getStringForText:@"ok" forLocale:@"fr"], nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert setTag:10];
    [alert show];
}

- (IBAction)twitterBtnPressed:(id)sender {
    Localization *localization = [[Localization alloc] init];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:[localization getStringForText:@"please type your twitter profile url" forLocale:@"fr"] delegate:self cancelButtonTitle:[localization getStringForText:@"cancel" forLocale:@"fr"] otherButtonTitles:[localization getStringForText:@"ok" forLocale:@"fr"], nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert setTag:20];
    [alert show];
}

- (IBAction)instagramBtnPressed:(id)sender {
    Localization *localization = [[Localization alloc] init];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Instagram" message:[localization getStringForText:@"please type your instagram profile url" forLocale:@"fr"] delegate:self cancelButtonTitle:[localization getStringForText:@"cancel" forLocale:@"fr"] otherButtonTitles:[localization getStringForText:@"ok" forLocale:@"fr"], nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert setTag:30];
    [alert show];
}

- (IBAction)pinterestBtnPressed:(id)sender {
    Localization *localization = [[Localization alloc] init];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Pinterest" message:[localization getStringForText:@"please type your pinterest profile url" forLocale:@"fr"] delegate:self cancelButtonTitle:[localization getStringForText:@"cancel" forLocale:@"fr"] otherButtonTitles:[localization getStringForText:@"ok" forLocale:@"fr"], nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert setTag:40];
    [alert show];
}

- (IBAction)googleBtnPressed:(id)sender {
    Localization *localization = [[Localization alloc] init];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Google+" message:[localization getStringForText:@"please type your google+ profile url" forLocale:@"fr"] delegate:self cancelButtonTitle:[localization getStringForText:@"cancel" forLocale:@"fr"] otherButtonTitles:[localization getStringForText:@"ok" forLocale:@"fr"], nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert setTag:50];
    [alert show];
}

- (BOOL)getSelectedCategories {
    if (self.nSelected != 3) {
        Localization *localization = [[Localization alloc] init];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"error" forLocale:@"fr"] message:@"" delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
        alert.message = [localization getStringForText:@"you need to select 3 categories" forLocale:@"fr"];
        [alert show];
    } else {
        NSArray *btns = [[NSArray alloc] initWithObjects:
                         _modeBtn, _beauteBtn, _diyBtn,
                         _voyagesBtn, _decorationBtn, _fitnessBtn,
                         _foodBtn, _mariageBtn, _famileBtn, nil];
        
        int j = 0;
        for (int i = 0; i < 9; i++) {
            UIButton *btn = btns[i];
            
            if ([btn isSelected]) {
                if (j == 0)
                    self.cat1 = i+1;
                else if (j == 1)
                    self.cat2 = i+1;
                else
                    self.cat3 = i+1;
                
                j++;
            }
        }
        
        return TRUE;
    }
    
    return FALSE;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10) {
        self.facebookUrl = [alertView textFieldAtIndex:0].text;
        
        if (self.facebookUrl.length)
            _facebookBtn.selected = YES;
        else
            _facebookBtn.selected = NO;
    } else if (alertView.tag == 20) {
        self.twitterUrl = [alertView textFieldAtIndex:0].text;
        
        if (self.twitterUrl.length)
            _twitterBtn.selected = YES;
        else
            _twitterBtn.selected = NO;
    } else if (alertView.tag == 30) {
        self.instagramUrl = [alertView textFieldAtIndex:0].text;
        
        if (self.instagramUrl.length)
            _instagramBtn.selected = YES;
        else
            _instagramBtn.selected = NO;
    } else if (alertView.tag == 40) {
        self.pinterestUrl = [alertView textFieldAtIndex:0].text;
        
        if (self.pinterestUrl.length)
            _pinterestBtn.selected = YES;
        else
            _pinterestBtn.selected = NO;
    } else if (alertView.tag == 50) {
        self.googleUrl = [alertView textFieldAtIndex:0].text;
        
        if (self.googleUrl.length)
            _googleBtn.selected = YES;
        else
            _googleBtn.selected = NO;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
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
