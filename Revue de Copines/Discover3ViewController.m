//
//  Discover3ViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 05/01/15.
//  Copyright (c) 2015 Pears & Bragston. All rights reserved.
//

#import "Discover3ViewController.h"
#import "SimpleTableCell.h"
#import "User.h"
#import "Localization.h"

@interface Discover3ViewController ()

@end

@implementation Discover3ViewController {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set Search Bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 290, 64)];
    searchBar.delegate = self;
    searchBar.showsCancelButton = NO;
    [searchBar setPlaceholder:@"Recherche"];
    
    self.sdc = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:nil];
    self.navigationItem.titleView = self.sdc.searchBar;
    self.sdc.displaysSearchBarInNavigationBar = YES;
    
    // Set Right Bar Button Item
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Terminé" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    backItem.tintColor = [UIColor whiteColor];
    [backItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Apercu" size:16]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = backItem;
    
    // Hide Back Button
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.sdc.displaysSearchBarInNavigationBar = NO;
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    NSString *searchString = searchBar.text;
    
    User *user = [User getInstance];
    
    NSString *sUrl = [NSString stringWithFormat:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getBlogListBySearch?id=%ld&query=%@", (long)user.userId, searchString];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    
    NSLog(@"%@", data);
    
    tableData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y + 20, self.tableView.frame.size.width, self.tableView.frame.size.height - 65)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end