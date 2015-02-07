//
//  DataClass.h
//  Revue de Copines
//
//  Created by Fábio Violante on 17/06/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataClass : NSObject {
    NSString *userId;
}

@property (retain, nonatomic) NSString *userId;

+(DataClass *)getInstance;

@end
