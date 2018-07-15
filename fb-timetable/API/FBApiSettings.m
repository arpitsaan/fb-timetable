//
//  FBApiSettings.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBApiSettings.h"

@implementation FBApiSettings

static NSString *_apiKey;
static NSURL *_apiPath;

+ (void)setApiPath:(NSURL *)apiPath {
    _apiPath = apiPath;
}

+ (NSURL *)getApiPath {
    return _apiPath;
}

+ (void)setApiKey:(NSString *)apiKey {
    _apiKey = apiKey;
}

+ (NSString *)getApiKey {
    return _apiKey;
}

@end
