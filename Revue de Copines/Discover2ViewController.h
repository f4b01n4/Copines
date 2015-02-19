//
//  Discover2ViewController.h
//  Revue de Copines
//
//  Created by Fábio Violante on 31/12/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverViewController.h"

@interface Discover2ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) DiscoverViewController *dvc;
@property (strong, nonatomic) NSString *pageTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int theme;

@end