//
//  DiscoverViewController.h
//  Revue de Copines
//
//  Created by Fábio Violante on 18/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;

@interface DiscoverViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) HomeViewController *hvc;
@property (strong, nonatomic) UIStoryboard *theStoryboard;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *mode;
@property (weak, nonatomic) IBOutlet UIButton *beaute;
@property (weak, nonatomic) IBOutlet UIButton *diy;
@property (weak, nonatomic) IBOutlet UIButton *voyages;
@property (weak, nonatomic) IBOutlet UIButton *decoration;
@property (weak, nonatomic) IBOutlet UIButton *fitness;
@property (weak, nonatomic) IBOutlet UIButton *food;
@property (weak, nonatomic) IBOutlet UIButton *mariage;
@property (weak, nonatomic) IBOutlet UIButton *famille;
@property (nonatomic) float originalTitleHeight;
@property (nonatomic) float originalTableHeight;

- (IBAction)modeBtn:(id)sender;
- (IBAction)beauteBtn:(id)sender;
- (IBAction)diyBtn:(id)sender;
- (IBAction)voyagesBtn:(id)sender;
- (IBAction)decorationBtn:(id)sender;
- (IBAction)fitnessBtn:(id)sender;
- (IBAction)foodBtn:(id)sender;
- (IBAction)mariageBtn:(id)sender;
- (IBAction)familleBtn:(id)sender;

- (void)popBack;

@end