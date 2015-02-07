//
//  CommentsViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 18/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "User.h"
#import "CommentsViewController.h"
#import "Localization.h"

@interface CommentsViewController ()

@end

CGFloat _currentKeyboardHeight = 0.0f;

@implementation CommentsViewController

@synthesize responseData = _responseData;
@synthesize userData = _userData;
@synthesize articleData = _articleData;

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
    
    // Hide Back Button
    self.navigationItem.hidesBackButton = YES;
    
    // Set Right Bar Button Item
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Terminé" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    backItem.tintColor = [UIColor whiteColor];
    [backItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Apercu" size:16]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = backItem;
    
    // Set Title
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    navTitle.text = @"Commentaires";
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [navTitle setFont:[UIFont fontWithName:@"Apercu-Bold" size:20]];
    self.navigationItem.titleView = navTitle;
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self parseComments];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) popBack {
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)parseComments {
    NSString *article_id = [_articleData objectForKey:@"article_id"];
    
    NSString *sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getComments?id=%@", article_id];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    self.placeholder = 0;
    self.commentsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 111)];
    [self.commentsView setScrollEnabled:YES];
    
    int count = [[res objectForKey:@"count"] intValue];
    
    if (count) {
        for (int i = 0; i< count; i++) {
            UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.placeholder, self.view.frame.size.width, 100)];
            
            // Profile Picture
            UIImageView *profileImageView;
            
            NSString *photo = [[[res objectForKey:@"data"][i] objectForKey:@"user"] objectForKey:@"photo"];
            if(photo != (id)[NSNull null]) {
                id path = photo;
                NSURL *imageUrl = [NSURL URLWithString:path];
                NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
                UIImage *profileImg = [[UIImage alloc] initWithData:imageData];
                profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 51, 51)];
                [profileImageView setImage:profileImg];
            }
            
            // User Name
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(79, 10, self.view.frame.size.width - 100, 20)];
            [nameLabel setFont:[UIFont fontWithName:@"Apercu" size:14]];
            [nameLabel setTextColor:[UIColor blackColor]];
            nameLabel.text = [NSString stringWithFormat:@"%@ %@", [[[res objectForKey:@"data"][i] objectForKey:@"user"] objectForKey:@"first_name"], [[[res objectForKey:@"data"][i] objectForKey:@"user"] objectForKey:@"name"]];
            
            // Comment Time
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 10, 30, 20)];
            [timeLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:12]];
            [timeLabel setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
            [timeLabel setTextAlignment:NSTextAlignmentRight];
            timeLabel.text = [[res objectForKey:@"data"][i] objectForKey:@"time"];
            
            // Comment View
            float totalHeight = 25;
            
            UITextView *contentLabel = [[UITextView alloc] initWithFrame:CGRectMake(74, totalHeight, self.view.frame.size.width - 100, 100)];
            [contentLabel setDelegate:self];
            [contentLabel setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
            [contentLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:14]];
            [contentLabel setEditable:NO];
            [contentLabel setSelectable:NO];
            [contentLabel setScrollEnabled:NO];
            [contentLabel setTextAlignment:NSTextAlignmentJustified];
            
            NSData *commentDataFromBase64String = [[NSData alloc] initWithBase64EncodedString:[[res objectForKey:@"data"][i] objectForKey:@"content"] options:0];
            NSString *base64Decoded = [[NSString alloc] initWithData:commentDataFromBase64String encoding:NSUTF8StringEncoding];
            [contentLabel setText:base64Decoded];
            
            CGSize contentSize = [contentLabel sizeThatFits:CGSizeMake(self.view.frame.size.width - 100, 100000)];
            CGRect frame = contentLabel.frame;
            frame.size = CGSizeMake(contentSize.width, contentSize.height);
            contentLabel.frame = frame;
            
            if (frame.size.height > 45)
                totalHeight += frame.size.height;
            else
                totalHeight += 45;
            
            // Bottom Bar
            UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, totalHeight, self.view.frame.size.width, 1)];
            [bottomBar setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
            
            [commentView addSubview:profileImageView];
            [commentView addSubview:contentLabel];
            [commentView addSubview:nameLabel];
            [commentView addSubview:timeLabel];
            [commentView addSubview:bottomBar];
            
            [self.commentsView addSubview:commentView];
            
            self.placeholder += (totalHeight + 1);
        }
    }
    
    self.commentsView.contentSize = CGSizeMake(self.view.frame.size.width, self.placeholder + 20);
    [self.view addSubview:self.commentsView];
    
    UIView *commentBox = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 115, self.view.frame.size.width, 51)];
    [commentBox setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:0.92 alpha:1]];
    self.commentField = [[UITextField alloc] initWithFrame:CGRectMake(10, 11, self.view.frame.size.width - 123, 29)];
    [self.commentField setBackgroundColor:[UIColor whiteColor]];
    [self.commentField setTextColor:[UIColor blackColor]];
    [self.commentField setPlaceholder:@"Ajouter un commentaire"];
    [self.commentField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.commentField setFont:[UIFont fontWithName:@"Apercu-Light" size:12]];

    [self.commentField setDelegate:self];
    [commentBox addSubview:self.commentField];
    UIImage *sendImg = [UIImage imageNamed:@"envoyer.png"];
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setImage:sendImg forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(self.view.frame.size.width - 103, 11, 93, 29);
    [sendBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [commentBox addSubview:sendBtn];
    
    [self.view addSubview:commentBox];
}

- (void)sendComment {
    NSData *commentData = [self.commentField.text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [commentData base64EncodedStringWithOptions:0];
    
    base64Encoded = [base64Encoded stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    base64Encoded = [base64Encoded stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    if (self.commentField.text.length > 0) {
        User *user = [User getInstance];
        
        NSString *article_id = [_articleData objectForKey:@"article_id"];
        NSString *sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/newComment?id=%@&user=%ld&content=%@", article_id, (long)user.userId, base64Encoded];
        
        NSURL *url = [NSURL URLWithString:sUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error = nil;
        
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.placeholder, 320, 100)];
        
        // Profile Picture
        NSString *photo = user.photo;
        id path = photo;
        NSURL *imageUrl = [NSURL URLWithString:path];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        UIImage *profileImg = [[UIImage alloc] initWithData:imageData];
        UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 51, 51)];
        [profileImageView setImage:profileImg];
        
        // User Name
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(79, 10, 220, 20)];
        [nameLabel setFont:[UIFont fontWithName:@"Apercu" size:14]];
        [nameLabel setTextColor:[UIColor blackColor]];
        nameLabel.text = user.name;
        
        // Comment Time
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 10, 30, 20)];
        [timeLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:12]];
        [timeLabel setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        timeLabel.text = @"";
        
        // Comment View
        float totalHeight = 25;
        
        UITextView *contentLabel = [[UITextView alloc] initWithFrame:CGRectMake(74, totalHeight, 220, 100)];
        [contentLabel setDelegate:self];
        [contentLabel setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
        [contentLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:14]];
        [contentLabel setEditable:NO];
        [contentLabel setSelectable:NO];
        [contentLabel setScrollEnabled:NO];
        [contentLabel setTextAlignment:NSTextAlignmentJustified];
        [contentLabel setText:self.commentField.text];
        
        CGSize contentSize = [contentLabel sizeThatFits:CGSizeMake(220, 100000)];
        CGRect frame = contentLabel.frame;
        frame.size = CGSizeMake(contentSize.width, contentSize.height);
        contentLabel.frame = frame;
        
        if (frame.size.height > 45)
            totalHeight += frame.size.height;
        else
            totalHeight += 45;
        
        // Bottom Bar
        UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, totalHeight, 320, 1)];
        [bottomBar setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
        
        [commentView addSubview:profileImageView];
        [commentView addSubview:contentLabel];
        [commentView addSubview:nameLabel];
        [commentView addSubview:timeLabel];
        [commentView addSubview:bottomBar];
        
        [self.commentsView addSubview:commentView];
        
        self.placeholder += (totalHeight + 1);
        
        self.commentsView.contentSize = CGSizeMake(320, self.placeholder + 20);
    }
    
    self.commentField.text = @"";
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    
    if (nextResponder)
        [nextResponder becomeFirstResponder];
    else
        [textField resignFirstResponder];
    
    return NO;
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat deltaHeight = kbSize.height - _currentKeyboardHeight;
    
    [self animateTextFieldUp:YES withHeight:deltaHeight widthDuration:duration];
    
    _currentKeyboardHeight = kbSize.height;
}

- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self animateTextFieldUp:NO withHeight:kbSize.height widthDuration:duration];
    
    _currentKeyboardHeight = 0.0f;
}

- (void)animateTextFieldUp:(BOOL)up withHeight:(CGFloat)height widthDuration:(NSTimeInterval)duration {
    int movementDistance = (int)height;
    float movementDuration = duration;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
