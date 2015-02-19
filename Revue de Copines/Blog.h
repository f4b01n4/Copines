//
//  Blog.h
//  Revue de Copines
//
//  Created by Fábio Violante on 01/11/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Blog : NSObject <NSCoding> {
    NSInteger blogId;
    NSInteger userId;
    NSString *name;
    NSString *url;
    NSString *backgroundImage;
    NSArray *themes;
    NSString *blogDescription;
    NSInteger likes;
    NSInteger followers;
    NSInteger articles;
}

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic) NSString *backgroundImage;
@property (retain, nonatomic) NSArray *themes;
@property (retain, nonatomic) NSString *blogDescription;
@property (nonatomic) NSInteger blogId;
@property (nonatomic) NSInteger userId;
@property (nonatomic) NSInteger likes;
@property (nonatomic) NSInteger followers;
@property (nonatomic) NSInteger articles;

+(Blog*)getInstance;

-(void) save;

@end