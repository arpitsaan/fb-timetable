//
//  FBModelObject.h
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBModelObject : NSObject

- (void)parseObject:(NSDictionary *)responseObject withInitialParams:(NSDictionary *)params;

+ (NSInteger)getRetryCount;

+ (NSString *)getAPIPath;

+ (BOOL)shouldIgnoreCaching;

+ (NSString *)getAPIPathWithParams:(NSDictionary *)params;

- (NSString *)getStringForKey:(NSString *)key fromDictionary:(NSDictionary *)dictionary withInitialValue:(NSString *)initialValue;

- (NSNumber *)getNumberForKey:(NSString *)key fromDictionary:(NSDictionary *)dictionary withInitialValue:(NSNumber *)initialValue;

@end
