//
//  Localization.h
//  Revue de Copines
//
//  Created by Fábio Violante on 29/12/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Localization : NSObject

-(NSString*) getStringForText:(NSString *)text forLocale:(NSString *)locale;

@end