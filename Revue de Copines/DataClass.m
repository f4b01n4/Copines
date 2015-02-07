//
//  DataClass.m
//  Revue de Copines
//
//  Created by Fábio Violante on 17/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "DataClass.h"

@implementation DataClass

@synthesize userId;

static DataClass *instance = nil;

+(DataClass *)getInstance {
    @synchronized(self) {
        if (instance == nil)
            instance = [DataClass new];
    }
    
    return instance;
}

@end
