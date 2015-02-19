//
//  Article.m
//  Revue de Copines
//
//  Created by Fábio Violante on 01/11/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "Article.h"

@implementation Article

@synthesize articleId;
@synthesize blogId;
@synthesize photo;
@synthesize title;
@synthesize content;
@synthesize url;
@synthesize likes;
@synthesize comments;

static Article *instance = nil;
static NSString* const ArticleDataArticleIdKey = @"articleId";

+(Article *) getInstance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [Article new];
            //instance = [self loadInstance];
        }
    }
    
    return instance;
}

+(NSString*) filePath {
    static NSString* filePath = nil;
    
    if (!filePath)
        filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"appdata"];
    
    return filePath;
}

+(instancetype) loadInstance {
    NSData* decodedData = [NSData dataWithContentsOfFile:[Article filePath]];
    
    if (decodedData) {
        Article* appData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        
        return appData;
    }
    
    return [[Article alloc] init];
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.articleId forKey:ArticleDataArticleIdKey];
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    
    if (self)
        articleId = [aDecoder decodeIntegerForKey:ArticleDataArticleIdKey];
    
    return self;
}

-(void) save {
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[Article filePath] atomically:YES];
}

@end