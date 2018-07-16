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
    
    NSString *returnValue = initialValue;
    @try {
        returnValue = [dictionary valueForKeyPath:key];
    }
    @catch (NSException *exception) {
        NSLog(@"[Exception] getStringForKey - %@", exception.description);
    }
    
    if (returnValue == nil) {
        return initialValue;
    }
    else if ([returnValue isKindOfClass:[NSNumber class]]) {
        returnValue = [NSString stringWithFormat:@"%@", returnValue];
    }
    
    if ([returnValue isKindOfClass:[NSString class]] || [returnValue isKindOfClass:[NSNumber class]]) {
        return returnValue;
    }
    else {
        return initialValue;
    }
}

- (NSNumber *)getNumberForKey:(NSString *)key fromDictionary:(NSDictionary *)dictionary withInitialValue:(NSNumber *)initialValue {
    
    NSNumber *returnValue = initialValue;
    
    @try {
        returnValue = [dictionary valueForKeyPath:key];
    }
    @catch (NSException *exception) {
        NSLog(@"[Exception] getNumberForKey - %@", exception.description);
    }
    
    if (returnValue == nil) {
        return initialValue;
    }
    else if ([returnValue isKindOfClass:[NSString class]]) {
        NSString *tempString = (NSString *)returnValue;
        @try {
            returnValue = [NSDecimalNumber decimalNumberWithString:tempString];
        }
        @catch (NSException *exception) {
            NSLog(@"[Exception] getNumberForKey - %@", exception.description);
        }
    }

    
    if ([returnValue isKindOfClass:[NSString class]] || [returnValue isKindOfClass:[NSNumber class]]) {
        return returnValue;
    }
    else {
        return initialValue;
    }
}


@end
