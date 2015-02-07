//
//  Blog.m
//  Revue de Copines
//
//  Created by Fábio Violante on 01/11/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "Blog.h"

@implementation Blog

@synthesize blogId;
@synthesize userId;
@synthesize name;
@synthesize url;
@synthesize backgroundImage;
@synthesize themes;
@synthesize blogDescription;
@synthesize likes;
@synthesize followers;
@synthesize articles;

static Blog *instance = nil;
static NSString* const BlogDataBlogIdKey = @"blogId";

+(Blog *) getInstance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [self loadInstance];
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
    NSData* decodedData = [NSData dataWithContentsOfFile:[Blog filePath]];
    
    if (decodedData) {
        Blog* appData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        
        return appData;
    }
    
    return [[Blog alloc] init];
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.blogId forKey:BlogDataBlogIdKey];
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    
    if (self)
        blogId = [aDecoder decodeIntegerForKey:BlogDataBlogIdKey];
    
    return self;
}

-(void) save {
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[Blog filePath] atomically:YES];
}

@end
