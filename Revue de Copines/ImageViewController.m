//
//  ImageViewController.m
//  Copines
//
//  Created by Fábio Violante on 18/03/15.
//  Copyright (c) 2015 Pears & Bragston. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

@synthesize image = _image;
@synthesize imagePath = _imagePath;
@synthesize imgView = _imgView;
@synthesize scrollView = _scrollView;
@synthesize backBtn = _backBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custome initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loader.alpha = 1.0;
    loader.center = CGPointMake((self.view.frame.size.width / 2), 100);
    loader.hidesWhenStopped = NO;
    
    [self.view addSubview:loader];
    [loader startAnimating];
    
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.imagePath]];
    
    [self downloadImageWithURL:imageUrl completionBlock:^(BOOL succeeded, UIImage *img) {
        if (succeeded) {
            [loader setHidden:YES];
            
            self.image = img;
            self.imgView = [[UIImageView alloc] initWithImage:self.image];
            self.imgView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=self.image.size};
            
            [self.scrollView addSubview:self.imgView];
            self.scrollView.contentSize = self.image.size;
            
            CGRect scrollViewFrame = self.scrollView.frame;
            CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
            CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
            CGFloat minScale = MIN(scaleWidth, scaleHeight);
            
            self.scrollView.minimumZoomScale = minScale;
            self.scrollView.maximumZoomScale = 1.5f;
            self.scrollView.zoomScale = minScale;
            [self.scrollView setZoomScale:minScale];

            [self centerScrollViewContents];
        }
    }];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
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

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView {
    return self.imgView;
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imgView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imgView.frame = contentsFrame;
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer {
    // 1
    CGPoint pointInView = [recognizer locationInView:self.imgView];
    
    // 2
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer *)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

- (void)scrollViewDidZoom:(UIScrollView*)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackBtnPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
