//
//  User.m
//  Revue de Copines
//
//  Created by Fábio Violante on 17/09/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "User.h"
#import "Localization.h"

@implementation User

@synthesize name;
@synthesize email;
@synthesize password;
@synthesize themes;
@synthesize userId;
@synthesize blogId;
@synthesize type;
@synthesize photo;
@synthesize cover_photo;
@synthesize photoImage;
@synthesize coverImage;
@synthesize blog_name;
@synthesize blog_localisation;
@synthesize blog_url;
@synthesize blog_description;
@synthesize blog_cat1;
@synthesize blog_cat2;
@synthesize blog_cat3;

static User *instance = nil;
static NSString* const UserDataUserIdKey = @"userId";

+(User *) getInstance {
    @synchronized(self) {
        if (instance == nil)
            instance = [self loadInstance];
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
    NSData* decodedData = [NSData dataWithContentsOfFile:[User filePath]];
    
    if (decodedData) {
        User* appData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        
        return appData;
    }
    
    return [[User alloc] init];
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.userId forKey:UserDataUserIdKey];
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    
    if (self) {
        userId = [aDecoder decodeIntegerForKey:UserDataUserIdKey];
    }
    
    return self;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL) validateUrl:(NSString *)candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    
    return [urlTest evaluateWithObject:candidate];
}

-(BOOL) validate {
    Localization *localization = [[Localization alloc] init];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"error" forLocale:@"fr"] message:@"" delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
    
    if (!self.name.length) {
        alert.message = [localization getStringForText:@"name is required" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    } else if (self.name.length > 100) {
        alert.message = [localization getStringForText:@"name should not contain more than 100 chars" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    }
    
    if (!self.email.length) {
        alert.message = [localization getStringForText:@"email is required" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    } else if (self.email.length > 255) {
        alert.message = [localization getStringForText:@"email should not contain more than 255 chars" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    }
    
    if (self.password.length < 8) {
        alert.message = [localization getStringForText:@"password should contain at least 8 chars" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    } else if (self.password.length > 64) {
        alert.message = [localization getStringForText:@"password should not contain more thant 64 chars" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    }
    
    if (![self NSStringIsValidEmail:self.email]) {
        alert.message = [localization getStringForText:@"email is invalid" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    }
    
    return TRUE;
}

-(BOOL) validateBlog {
    Localization *localization = [[Localization alloc] init];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"error" forLocale:@"fr"] message:@"" delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
    
    // TODO
    // The Images need to be checked in size, at least the cover image
    // user.photoImage = self.profilePhoto.image;
    // user.coverImage = self.coverPhoto.image;
    
    if (!self.blog_name.length) {
        alert.message = [localization getStringForText:@"blog name is required" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    } else if (self.blog_name.length > 100) {
        alert.message = [localization getStringForText:@"blog name should not contain more than 100 chars" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    }
    
    if (!self.blog_localisation.length) {
        alert.message = [localization getStringForText:@"blog localisation is required" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    } else if (self.blog_localisation.length > 100) {
        alert.message = [localization getStringForText:@"blog localisation should not contain more than 100 chars" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    }
    
    if (!self.blog_url.length) {
        alert.message = [localization getStringForText:@"blog url is required" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    }
    
    if (![self validateUrl:self.blog_url]) {
        alert.message = [localization getStringForText:@"blog url is invalid" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    }
    
    if (!self.blog_description.length) {
        alert.message = [localization getStringForText:@"blog description is required" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    } else if (self.blog_description.length > 480) {
        alert.message = [localization getStringForText:@"blog description should not contain more than 480 chars" forLocale:@"fr"];
        [alert show];
        
        return FALSE;
    }
    
    return TRUE;
}

-(BOOL) validEmail {
    NSString *requestString = [NSString stringWithFormat:@"email=%@", self.email];
    
    NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/verifyEmail"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:requestData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    if ([[dict objectForKey:@"success"] integerValue] == 0) {
        Localization *localization = [[Localization alloc] init];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"error" forLocale:@"fr"] message:@"" delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
        alert.message = [dict objectForKey:@"message"];
        [alert show];
        
        return FALSE;
    }
    
    return TRUE;
}

-(BOOL) save {
    NSString *themesString = [self.themes componentsJoinedByString:@","];
    
    NSString *requestString = [NSString stringWithFormat:@"name=%@&email=%@&password=%@&type=%@&themes=%@", self.name, self.email, self.password, [NSString stringWithFormat:@"%ld", (long)self.type], themesString];
    
    NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/register"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:requestData];

    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];

    NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    if ([[dict objectForKey:@"success"] integerValue] == 0) {
        Localization *localization = [[Localization alloc] init];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"error" forLocale:@"fr"] message:@"" delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
        alert.message = [dict objectForKey:@"message"];
        [alert show];
        
        return FALSE;
    }
    
    self.userId = [[[dict objectForKey:@"message"] objectForKey:@"id"] intValue];

    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[User filePath] atomically:YES];

    return TRUE;
}

-(void) saveBlogger {
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[User filePath] atomically:YES];
}

-(BOOL) update {
    NSString *themesString = [self.themes componentsJoinedByString:@","];
    
    NSString *requestString = [NSString stringWithFormat:@"id=%ld&name=%@&themes=%@", self.userId, self.name, themesString];
    
    NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/update"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:requestData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    self.userId = [[[dict objectForKey:@"message"] objectForKey:@"id"] intValue];
    
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[User filePath] atomically:YES];
    
    return TRUE;
}

-(void) logout {
    self.userId = nil;
    
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[User filePath] atomically:YES];
}

-(BOOL) login {
    NSString *requestString = [NSString stringWithFormat:@"email=%@&password=%@", self.email, self.password];
    
    NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/login"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:requestData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
    
    if ([dict[@"success"] isEqualToString:@"0"]) {
        Localization *localization = [[Localization alloc] init];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localization getStringForText:@"error" forLocale:@"fr"] message:dict[@"message"] delegate:nil cancelButtonTitle:[localization getStringForText:@"ok" forLocale:@"fr"] otherButtonTitles: nil];
        
        [alert show];
        
        return FALSE;
    }
    
    NSArray *userthemes = [dict[@"data"][0][@"themes"] componentsSeparatedByString:@","];
    
    self.name = [NSString stringWithFormat:@"%@ %@", dict[@"data"][0][@"first_name"], dict[@"data"][0][@"name"]];
    self.userId = [dict[@"data"][0][@"id"] intValue];
    self.type = [dict[@"data"][0][@"type"] intValue];
    self.themes = [NSMutableArray arrayWithArray:userthemes];
    
    self.photo = dict[@"data"][0][@"photo"];
    
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[User filePath] atomically:YES];
    
    return TRUE;
}

-(BOOL) isLogedIn {
    if (!self.userId) {
        [self clear];
        
        return FALSE;
    }
    
    NSString *requestString = [NSString stringWithFormat:@"id=%ld", (long)self.userId];
    
    NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://adlead.dynip.sapo.pt/revue-de-copines/back/ios/getUserInfo"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:requestData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    
    @try {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
        
        NSArray *userthemes = [dict[@"data"][0][@"themes"] componentsSeparatedByString:@","];
        
        self.name = [NSString stringWithFormat:@"%@ %@", dict[@"data"][0][@"first_name"], dict[@"data"][0][@"name"]];
        self.email = dict[@"data"][0][@"email"];
        self.photo = dict[@"data"][0][@"photo"];
        self.type = [dict[@"data"][0][@"type"] intValue];
        self.themes = [NSMutableArray arrayWithArray:userthemes];
        
        if (self.type == 2) {
            self.blog_name = dict[@"blog"][0][@"name"];
            self.blog_localisation = [NSString stringWithFormat:@"%@, %@", dict[@"data"][0][@"city"], dict[@"data"][0][@"country"]];
            self.blog_url = dict[@"blog"][0][@"url"];
            self.blog_description = dict[@"blog"][0][@"description"];
            
            NSArray *stringArray = [dict[@"blog"][0][@"themes"] componentsSeparatedByString: @","];
            
            self.blog_cat1 = [stringArray[0] intValue];
            self.blog_cat2 = [stringArray[1] intValue];
            self.blog_cat3 = [stringArray[2] intValue];
        }
        
        NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
        [encodedData writeToFile:[User filePath] atomically:YES];
        
        return TRUE;
    }
    @catch (NSException *e) {
        [self clear];
        
        return FALSE;
    }
}

-(void) clear {
    self.name = nil;
    self.email = nil;
    self.password = nil;
    self.themes = [[NSMutableArray alloc] initWithObjects:0, 0, 0, 0, 0, 0, 0, 0, 0, nil];
    self.userId = 0;
    self.type = 0;
    self.photo = nil;
}

-(NSString*) getThemeString:(int)theme {
    NSArray *userthemes = [[NSArray alloc] initWithObjects:@"", @"Mode", @"Beauté", @"DIY", @"Voyages", @"Décoration", @"Fitness", @"Food", @"Mariage", @"Famille", nil];
    
    return userthemes[theme];
}

@end