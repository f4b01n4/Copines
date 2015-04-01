//
//  DiscoverViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 18/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "DiscoverViewController.h"
#import "Discover2ViewController.h"
#import "HomeViewController.h"
#import "SimpleTableCell.h"
#import "User.h"
#import "Localization.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController {
    NSDictionary *tableData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Localization *localization = [[Localization alloc] init];
    
    // Hide Back Button
    self.navigationItem.hidesBackButton = YES;
    
    self.theStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.innerView.translatesAutoresizingMaskIntoConstraints = YES;
    for (UIView *subV in self.innerView.subviews)
        subV.translatesAutoresizingMaskIntoConstraints = YES;
    
    // Set Left Bar Button Item
    UIImage *buttonImage = [UIImage imageNamed:@"search.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width / 2, buttonImage.size.height / 2);
    [aButton addTarget:self action:@selector(searchBlogger) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    // Set Right Bar Button Item
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:[localization getStringForText:@"done" forLocale:@"fr"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    backItem.tintColor = [UIColor whiteColor];
    [backItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Apercu" size:16]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = backItem;
    
    // Set Title
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    navTitle.text = [localization getStringForText:@"discover" forLocale:@"fr"];
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [navTitle setFont:[UIFont fontWithName:@"Apercu-Bold" size:20]];
    self.navigationItem.titleView = navTitle;
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.titleLabel setFont:[UIFont fontWithName:@"Apercu-Light" size:16]];
    
    User *user = [User getInstance];
    
    NSString *sUrl = [NSString stringWithFormat:@"http://ec2-54-170-94-162.eu-west-1.compute.amazonaws.com/ios/getCompleteCopinesList?id=%ld", (long)user.userId];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    
    tableData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
}

- (void)searchBlogger {
    Localization *localization = [[Localization alloc] init];
    
    Discover2ViewController *discover2ViewController;
    discover2ViewController = [self.theStoryboard instantiateViewControllerWithIdentifier:@"Discover3ViewController"];
    discover2ViewController.dvc = self;
    discover2ViewController.pageTitle = [localization getStringForText:@"search" forLocale:@"fr"];
    
    [self.navigationController pushViewController:discover2ViewController animated:YES];
}

- (void)fixSizes {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // Initial fix for the ScrollView with
    [self.scrollView setFrame:screenRect];
    
    // Fix the Blocks sizes and positions
    float blockWidth = 96;
    float blockHeight = 107;
    float blockStart = 10;
    float blockSpacing = 6;
    
    float aSpacing = self.scrollView.frame.size.width * blockSpacing / 320;
    float aBlockWidth = self.scrollView.frame.size.width * blockWidth / 320;
    float aBlockHeight = self.scrollView.frame.size.width * blockHeight / 320;
    
    float aBlockStart1X = self.scrollView.frame.size.width * blockStart / 320;
    float aBlockStart2X = self.scrollView.frame.size.width * (blockStart + blockWidth + blockSpacing) / 320;
    float aBlockStart3X = self.scrollView.frame.size.width * (blockStart + ((blockWidth + blockSpacing) * 2)) / 320;
    
    float aBlockStart1Y = self.scrollView.frame.size.width * blockStart / 320;
    float aBlockStart2Y = self.scrollView.frame.size.width * (blockStart + blockHeight + blockSpacing) / 320;
    float aBlockStart3Y = self.scrollView.frame.size.width * (blockStart + ((blockHeight + blockSpacing) * 2)) / 320;
    
    [self.mode setFrame:CGRectMake(aBlockStart1X, aBlockStart1Y, aBlockWidth, aBlockHeight)];
    [self.beaute setFrame:CGRectMake(aBlockStart2X, aBlockStart1Y, aBlockWidth, aBlockHeight)];
    [self.diy setFrame:CGRectMake(aBlockStart3X, aBlockStart1Y, aBlockWidth, aBlockHeight)];
    
    [self.voyages setFrame:CGRectMake(aBlockStart1X, aBlockStart2Y, aBlockWidth, aBlockHeight)];
    [self.decoration setFrame:CGRectMake(aBlockStart2X, aBlockStart2Y, aBlockWidth, aBlockHeight)];
    [self.fitness setFrame:CGRectMake(aBlockStart3X, aBlockStart2Y, aBlockWidth, aBlockHeight)];
    
    [self.food setFrame:CGRectMake(aBlockStart1X, aBlockStart3Y, aBlockWidth, aBlockHeight)];
    [self.mariage setFrame:CGRectMake(aBlockStart2X, aBlockStart3Y, aBlockWidth, aBlockHeight)];
    [self.famille setFrame:CGRectMake(aBlockStart3X, aBlockStart3Y, aBlockWidth, aBlockHeight)];
    
    // Fix the Lable size and position
    float aLabelStartY = aBlockStart3Y + aBlockHeight + (aSpacing * 3);
    [self.titleLabel setFrame:CGRectMake(aBlockStart1X, aLabelStartY, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height)];
    
    // Fix the Table size and position
    float aTableStartY = aLabelStartY + self.titleLabel.frame.size.height + aSpacing;
    float aTableWidth = screenRect.size.width;
    float aTableHeight = [[tableData objectForKey:@"data"] count] * 67;
    
    [self.tableView setFrame:CGRectMake(0, aTableStartY, aTableWidth, aTableHeight)];
    
    // Fix the ScrollView and InnerView sizes
    float aInnerViewHeight = aTableStartY + aTableHeight + aSpacing;
    
    [self.scrollView setFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, screenRect.size.width, self.view.frame.size.height)];
    [self.innerView setFrame:CGRectMake(self.innerView.frame.origin.x, self.innerView.frame.origin.y, screenRect.size.width, aInnerViewHeight)];
    
    [self.scrollView setContentSize:self.innerView.frame.size];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLayoutSubviews {
    [self fixSizes];
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
    
    cell.tag = [[[tableData objectForKey:@"data"][indexPath.row] objectForKey:@"blog_id"] integerValue];
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
        [cell.checkImageView setTag:0];
        [cell.checkImageView setImage:[UIImage imageNamed:@"add-categories-gray.png"]];
    } else {
        [cell.checkImageView setTag:1];
        [cell.checkImageView setImage:[UIImage imageNamed:@"check-categories.png"]];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkCopine:)];
    singleTap.numberOfTapsRequired = 1;
    
    cell.checkImageView.userInteractionEnabled = YES;
    [cell.checkImageView addGestureRecognizer:singleTap];
    
    return cell;
}

- (void)checkCopine:(UITapGestureRecognizer*)recognizer {
    UIImageView *v = recognizer.view;
    SimpleTableCell *cell = v.superview.superview;
    User *user = [User getInstance];
    
    if (v.tag == 0) {
        [v setTag:1];
        [v setImage:[UIImage imageNamed:@"check-categories.png"]];
        
        // Subscribe to Blog
        NSString *sUrl = [NSString stringWithFormat:@"http://ec2-54-170-94-162.eu-west-1.compute.amazonaws.com/ios/subscribeToBlog?id=%ld&blog=%ld", (long)user.userId, (long)cell.tag];
        
        NSURL *url = [NSURL URLWithString:sUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error = nil;
        
        [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    } else {
        [v setTag:0];
        [v setImage:[UIImage imageNamed:@"add-categories-gray.png"]];
        
        // Unsubscribe to Blog
        NSString *sUrl = [NSString stringWithFormat:@"http://ec2-54-170-94-162.eu-west-1.compute.amazonaws.com/ios/unsubscribeToBlog?id=%ld&blog=%ld", (long)user.userId, (long)cell.tag];
        
        NSURL *url = [NSURL URLWithString:sUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error = nil;
        
        [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SimpleTableCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self.hvc viewCopineFromDiscover:theCell.tag withTitle:theCell.nameLabel.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) popBack {
    [self.hvc reinitCategoriesLoading];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:1];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hvc rebuildMenuCopinesList];
            [self.hvc reinitCategories];
        });
    });

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
