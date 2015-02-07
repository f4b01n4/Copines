//
//  PageScrollViewController.m
//  Revue de Copines
//
//  Created by Fábio Violante on 15/10/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "PageScrollViewController.h"

@interface PageScrollViewController ()

@end

@implementation PageScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView *articleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 508)];
    [articleView setScrollEnabled:YES];
    [articleView setPagingEnabled:YES];
    [articleView setBackgroundColor:[UIColor blueColor]];
    
    articleView.contentSize = CGSizeMake(320, 1000);
    
    [self.view addSubview:articleView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
