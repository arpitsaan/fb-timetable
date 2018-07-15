//
//  FBAPIInitializer.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBAPIInitializer.h"
#import "FBApiManager.h"

NSString *kFlixbusHostUrlString = @"http://api.mobile.staging.mfb.io/";
NSString *kFlixbusInterViewApiKey = @"intervIEW_TOK3n";

@implementation FBAPIInitializer

+ (void)initializeApi {
    [[FBAPIInitializer sharedInitializer] initializeClass];
}

+ (FBAPIInitializer *)sharedInitializer {
    static FBAPIInitializer *_sharedInitializer = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInitializer = [[FBAPIInitializer alloc] init];
    });
    
    return _sharedInitializer;
}

- (void)initializeClass {
    [FBApiManager setApiPath:[NSURL URLWithString:kFlixbusHostUrlString]];
    [FBApiManager setApiKey:kFlixbusInterViewApiKey];
    [[FBApiManager sharedInstance] initialize];
}

@end
