//
//  FBModelObject.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBModelObject.h"

@implementation FBModelObject

- (void)parseObject:(NSDictionary *)responseObject withInitialParams:(NSDictionary *)params {    
}

+ (NSString *)getAPIPath{
    return nil;
}

+ (NSString *) getAPIPathWithParams:(NSDictionary *)params{
    return nil;
}

+ (NSInteger) getRetryCount{
    return 3;
}

+ (BOOL)shouldIgnoreCaching {
    return NO;
}

- (NSString *)getStringForKey:(NSString *)key fromDictionary:(NSDictionary *)dictionary withInitialValue:(NSString *)initialValue {
    return @"";
}

- (NSNumber *)getNumberForKey:(NSString *)key fromDictionary:(NSDictionary *)dictionary withInitialValue:(NSNumber *)initialValue {
    return @(0);
}


@end
