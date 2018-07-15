//
//  FBApiSettings.h
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBApiSettings : NSObject

+ (void)setApiPath:(NSURL *)apiPath;
+ (NSURL *)getApiPath;

+ (void)setApiKey:(NSString *)apiKey;
+ (NSString *)getApiKey;

@end
