//
//  User.h
//  Revue de Copines
//
//  Created by Fábio Violante on 17/09/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding> {
    NSString *name;
    NSString *email;
    NSString *password;
    NSMutableArray *themes;
    NSInteger userId;
    NSInteger type;
    NSString *photo;
    NSString *cover_photo;
    UIImage *photoImage;
    UIImage *coverImage;
    NSInteger blogId;
    NSString *blog_name;
    NSString *blog_localisation;
    NSString *blog_url;
    NSString *blog_description;
    NSInteger blog_cat1;
    NSInteger blog_cat2;
    NSInteger blog_cat3;
}

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSMutableArray *themes;
@property (retain, nonatomic) NSString *photo;
@property (retain, nonatomic) NSString *cover_photo;
@property (retain, nonatomic) UIImage *photoImage;
@property (retain, nonatomic) UIImage *coverImage;
@property (retain, nonatomic) NSString *blog_name;
@property (retain, nonatomic) NSString *blog_localisation;
@property (retain, nonatomic) NSString *blog_url;
@property (retain, nonatomic) NSString *blog_description;
@property (nonatomic) NSInteger userId;
@property (nonatomic) NSInteger blogId;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger blog_cat1;
@property (nonatomic) NSInteger blog_cat2;
@property (nonatomic) NSInteger blog_cat3;

+(User*)getInstance;

-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
-(BOOL) validate;
-(BOOL) validateBlog;
-(BOOL) save;
-(void) saveBlogger;
-(BOOL) validEmail;
-(BOOL) update;
-(BOOL) login;
-(void) logout;
-(BOOL) isLogedIn;
-(void) clear;
-(NSString*) getThemeString:(int)theme;

@end