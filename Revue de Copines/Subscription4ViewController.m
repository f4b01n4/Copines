//
//  Subscription4ViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 14/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "Subscription4ViewController.h"
#import "HomeViewController.h"
#import "SidebarViewController.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "Localization.h"

@interface Subscription4ViewController ()

@end

@implementation Subscription4ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.registerItem = [[UIBarButtonItem alloc] initWithTitle:@"Enregistrer" style:UIBarButtonItemStylePlain target:self action:@selector(register)];
    self.backItem = [[UIBarButtonItem alloc] initWithTitle:@"Annuler" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    
    self.registerItem.tintColor = [UIColor whiteColor];
    self.backItem.tintColor = [UIColor whiteColor];
    [self.registerItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Apercu" size:16]} forState:UIControlStateNormal];
    [self.backItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Apercu" size:16]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = self.registerItem;
    self.navigationItem.leftBarButtonItem = self.backItem;
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    navTitle.text = @"S'inscrire";
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)getSelectedCategories {
    Localization *localization = [[Localization alloc] init];
    
    if (self.nSelected != 3) {
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

-(void) register {
    Localization *localization = [[Localization alloc] init];
    
    NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/checkConnection"] encoding:NSUTF8StringEncoding error:nil];
    
    if (![connect isEqualToString:@"success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"no internet connection" forLocale:@"fr"] message:[localization getStringForText:@"you must be connected to the internet" forLocale:@"fr"] delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
        
        [alert show];
    } else {
        User *user = [User getInstance];
        
        if (![self getSelectedCategories])
            return;
        
        user.blog_name = self.nameInput.text;
        user.blog_localisation = self.localisationInput.text;
        user.blog_url = self.blogInput.text;
        user.blog_description = self.bioInput.text;
        user.blog_cat1 = self.cat1;
        user.blog_cat2 = self.cat2;
        user.blog_cat3 = self.cat3;
        user.photoImage = self.profilePhoto.image;
        user.coverImage = self.coverPhoto.image;
        
        if ([user validateBlog]) {
            [self.backItem setEnabled:FALSE];
            [self.registerItem setEnabled:FALSE];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = [localization getStringForText:@"creating account" forLocale:@"fr"];
            hud.detailsLabelText = [localization getStringForText:@"please wait" forLocale:@"fr"];
            
            // TODO - should be removed
            // TODO - should be removed
            // TODO - should be removed
            // TODO - should be removed
            // TODO - should be removed
            // TODO - should be removed
            // TODO - should be removed
            // TODO - should be removed
            // TODO - should be removed
            // TODO - should be removed
            // TODO - should be removed
            // TODO - should be removed
            //return;
            
            NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
            NSString *themesString = [user.themes componentsJoinedByString:@","];
            [_params setObject:user.name forKey:@"user_name"];
            [_params setObject:user.email forKey:@"user_email"];
            [_params setObject:user.password forKey:@"user_password"];
            [_params setObject:[NSString stringWithFormat:@"%ld", (long)user.type] forKey:@"user_type"];
            [_params setObject:themesString forKey:@"user_themes"];
            [_params setObject:user.blog_name forKey:@"blog_name"];
            [_params setObject:user.blog_localisation forKey:@"blog_localisation"];
            [_params setObject:user.blog_url forKey:@"blog_url"];
            [_params setObject:[NSString stringWithFormat:@"%ld", (long)user.blog_cat1] forKey:@"blog_cat1"];
            [_params setObject:[NSString stringWithFormat:@"%ld", (long)user.blog_cat2] forKey:@"blog_cat2"];
            [_params setObject:[NSString stringWithFormat:@"%ld", (long)user.blog_cat3] forKey:@"blog_cat3"];
            [_params setObject:user.blog_description forKey:@"blog_description"];
             
            NSData *profileImageData = UIImageJPEGRepresentation(user.photoImage, 100);
            NSData *coverImageData = UIImageJPEGRepresentation(user.coverImage, 100);
             
            NSString *urlString = @"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/registerBlogger/";
             
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
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                NSData *jsonData = [returnString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
                
                if ([[dict objectForKey:@"success"] integerValue] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.backItem setEnabled:TRUE];
                        [self.registerItem setEnabled:TRUE];
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"error" forLocale:@"fr"] message:@"" delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
                        
                        if ([[dict objectForKey:@"msg"] length] > 0)
                            alert.message = [dict objectForKey:@"msg"];
                        else
                            alert.message = [dict objectForKey:@"message"];
                        
                        [alert show];
                    });
                } else {
                    user.userId = [[[dict objectForKey:@"user"] objectForKey:@"id"] integerValue];
                    user.blogId = [[[dict objectForKey:@"blog"] objectForKey:@"id"] integerValue];
                    [user saveBlogger];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.backItem setEnabled:TRUE];
                        [self.registerItem setEnabled:TRUE];
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        self.homeViewController = [[HomeViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
                        
                        [self.navigationController pushViewController:self.homeViewController animated:NO];
                    });
                }
            });
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder && nextTag != 3) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextView: textView up: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView: textView up: NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        
        return NO;
    } else
        return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    if (textField.tag == 3) {
        const int movementDistance = 150; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        
        int movement = (up ? -movementDistance : movementDistance);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

- (void) animateTextView: (UITextView*) textView up: (BOOL) up
{
    const int movementDistance = 200; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
