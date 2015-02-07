//
//  DiscoverViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 18/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "DiscoverViewController.h"
#import "Discover2ViewController.h"
#import "SimpleTableCell.h"
#import "User.h"
#import "Localization.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController {
    NSDictionary *tableData;
}

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
    
    self.theStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Set Left Bar Button Item
    UIImage *buttonImage = [UIImage imageNamed:@"search.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width / 2, buttonImage.size.height / 2);
    [aButton addTarget:self action:@selector(searchBlogger) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    // Set Right Bar Button Item
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Terminé" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    backItem.tintColor = [UIColor whiteColor];
    [backItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Apercu" size:16]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = backItem;
    
    // Set Title
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    navTitle.text = @"Découvrir";
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [navTitle setFont:[UIFont fontWithName:@"Apercu-Bold" size:20]];
    self.navigationItem.titleView = navTitle;
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.titleLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:16]];
    
    User *user = [User getInstance];
    
    NSString *sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getCompleteCopinesList?id=%ld", (long)user.userId];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    
    tableData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    self.originalTitleHeight = self.titleLabel.frame.size.height;
    self.originalTableHeight = self.tableView.frame.size.height;
}

- (void)searchBlogger {
    Discover2ViewController *discover2ViewController;
    discover2ViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"Discover3ViewController"];
    discover2ViewController.dvc = self;
    discover2ViewController.pageTitle = @"Recherche";
    //discover2ViewController.theme = 0;
    
    [self.navigationController pushViewController:discover2ViewController animated:YES];
}

- (void)viewDidLayoutSubviews {
    if (self.view.frame.size.width <= 320) {
        [self.titleLabel sizeToFit];
        [self.titleLabel setFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.originalTitleHeight - 3)];
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.originalTableHeight - 10)];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[tableData objectForKey:@"data"] count];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else {
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    SimpleTableCell *cell = (SimpleTableCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSArray *themes = [[NSArray alloc] initWithObjects:@"", @"Mode", @"Beauté", @"DIY", @"Voyages", @"Décoration", @"Fitness", @"Food", @"Mariage", @"Famille", nil];
    NSArray *_themes = [[[tableData objectForKey:@"data"][indexPath.row] objectForKey:@"blog_themes"] componentsSeparatedByString:@","];
    int theme1 = [_themes[0] integerValue];
    int theme2 = [_themes[1] integerValue];
    int theme3 = [_themes[2] integerValue];
    int like = [[[tableData objectForKey:@"data"][indexPath.row] objectForKey:@"own_blog_like"] integerValue];
    
    cell.nameLabel.text = [[tableData objectForKey:@"data"][indexPath.row] objectForKey:@"blog_name"];
    cell.themesLabel.text = [NSString stringWithFormat:@"%@, %@, %@", themes[theme1], themes[theme2], themes[theme3]];
    
    NSString *photo = [[tableData objectForKey:@"data"][indexPath.row] objectForKey:@"user_photo"];
    if (photo != (id)[NSNull null]) {
        id path = photo;
        NSURL *imageUrl = [NSURL URLWithString:path];
        
        [self downloadImageWithURL:imageUrl completionBlock:^(BOOL succeeded, UIImage *img) {
            if (succeeded)
                cell.photoImageView.image = img;
        }];
    }
    
    if (like == 0) {
        [cell.checkImageView setAlpha:0.5f];
        [cell.checkImageView setTag:0];
    } else {
        [cell.checkImageView setAlpha:1.0f];
        [cell.checkImageView setTag:1];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkCopine:)];
    singleTap.numberOfTapsRequired = 1;
    cell.checkImageView.userInteractionEnabled = YES;
    [cell.checkImageView addGestureRecognizer:singleTap];
    
    return cell;
}

- (void)checkCopine:(UITapGestureRecognizer*)recognizer {
    UIView *v = recognizer.view;
    
    if (v.alpha == 0.5)
        [v setAlpha:1.0f];
    else
        [v setAlpha:0.5f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
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

- (IBAction)modeBtn:(id)sender {
    Discover2ViewController *discover2ViewController;
    discover2ViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"Discover2ViewController"];
    discover2ViewController.dvc = self;
    discover2ViewController.pageTitle = @"Mode";
    discover2ViewController.theme = 1;
    
    [self.navigationController pushViewController:discover2ViewController animated:YES];
}

- (IBAction)beauteBtn:(id)sender {
    Discover2ViewController *discover2ViewController;
    discover2ViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"Discover2ViewController"];
    discover2ViewController.dvc = self;
    discover2ViewController.pageTitle = @"Beauté";
    discover2ViewController.theme = 2;
    
    [self.navigationController pushViewController:discover2ViewController animated:YES];
}

- (IBAction)diyBtn:(id)sender {
    Discover2ViewController *discover2ViewController;
    discover2ViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"Discover2ViewController"];
    discover2ViewController.dvc = self;
    discover2ViewController.pageTitle = @"DIY & Craft";
    discover2ViewController.theme = 3;
    
    [self.navigationController pushViewController:discover2ViewController animated:YES];
}

- (IBAction)voyagesBtn:(id)sender {
    Discover2ViewController *discover2ViewController;
    discover2ViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"Discover2ViewController"];
    discover2ViewController.dvc = self;
    discover2ViewController.pageTitle = @"Voyages";
    discover2ViewController.theme = 4;
    
    [self.navigationController pushViewController:discover2ViewController animated:YES];
}

- (IBAction)decorationBtn:(id)sender {
    Discover2ViewController *discover2ViewController;
    discover2ViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"Discover2ViewController"];
    discover2ViewController.dvc = self;
    discover2ViewController.pageTitle = @"Décoration";
discover2ViewController.theme = 5;
    
    [self.navigationController pushViewController:discover2ViewController animated:YES];
}

- (IBAction)fitnessBtn:(id)sender {
    Discover2ViewController *discover2ViewController;
    discover2ViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"Discover2ViewController"];
    discover2ViewController.dvc = self;
    discover2ViewController.pageTitle = @"Fitness";
    discover2ViewController.theme = 6;
    
    [self.navigationController pushViewController:discover2ViewController animated:YES];
}

- (IBAction)foodBtn:(id)sender {
    Discover2ViewController *discover2ViewController;
    discover2ViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"Discover2ViewController"];
    discover2ViewController.dvc = self;
    discover2ViewController.pageTitle = @"Food & Drink";
    discover2ViewController.theme = 7;
    
    [self.navigationController pushViewController:discover2ViewController animated:YES];
}

- (IBAction)mariageBtn:(id)sender {
    Discover2ViewController *discover2ViewController;
    discover2ViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"Discover2ViewController"];
    discover2ViewController.dvc = self;
    discover2ViewController.pageTitle = @"Mariage";
    discover2ViewController.theme = 8;
    
    [self.navigationController pushViewController:discover2ViewController animated:YES];
}

- (IBAction)familleBtn:(id)sender {
    Discover2ViewController *discover2ViewController;
    discover2ViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"Discover2ViewController"];
    discover2ViewController.dvc = self;
    discover2ViewController.pageTitle = @"Famille";
    discover2ViewController.theme = 9;
    
    [self.navigationController pushViewController:discover2ViewController animated:YES];
}
@end
