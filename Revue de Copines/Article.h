//
//  Article.h
//  Revue de Copines
//
//  Created by Fábio Violante on 01/11/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject <NSCoding> {
    NSInteger articleId;
    NSInteger blogId;
    NSString *photo;
    NSString *title;
    NSString *content;
    NSString *url;
    NSInteger likes;
    NSInteger comments;
}

@property (retain, nonatomic) NSString *photo;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *url;
@property (nonatomic) NSInteger articleId;
@property (nonatomic) NSInteger blogId;
@property (nonatomic) NSInteger likes;
@property (nonatomic) NSInteger comments;

+(Article*)getInstance;

-(void) save;

@end