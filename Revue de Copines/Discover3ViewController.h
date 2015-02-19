//
//  Discover3ViewController.h
//  Revue de Copines
//
//  Created by Fábio Violante on 05/01/15.
//  Copyright (c) 2015 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverViewController.h"

@interface Discover3ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) DiscoverViewController *dvc;
@property (strong, nonatomic) NSString *pageTitle;
@property (strong, nonatomic) UISearchDisplayController *sdc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end