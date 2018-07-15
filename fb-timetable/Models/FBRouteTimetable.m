//
//  FBRouteTimetable.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBRouteTimetable.h"
#import "FBApiManager.h"

@implementation FBRouteTimetable

- (void)getFBRouteTimetable:(id<FBRouteTimetableDelegate>)delegate {
    self.delegate = delegate;
    
    [[FBApiManager sharedInstance] getRequestForClass:[self class] WithParameters:nil andRetryCount:3 withDelegate:self];
}

+ (NSString *)getAPIPath {
    return @"/mobile/v1/network/station/1/timetable";
}

+ (NSString *)getAPIPathWithParams:(NSDictionary *)params {
    return [self getAPIPath];
}

- (void)parseObject:(NSDictionary *)responseObject withInitialParams:(NSDictionary *)params {
    self.status = [self getStringForKey:@"response.status" fromDictionary:responseObject withInitialValue:self.status];
    self.message = [self getStringForKey:@"response.message" fromDictionary:responseObject withInitialValue:self.message];
}

- (void)didFetchObjects:(id)objects ForClass:(Class)klass withInitialParams:(NSDictionary *)params {
    NSLog(@"%@", objects);
}

- (void)didFailForClass:(Class)klass withError:(NSError *)error andInitialParams:(NSDictionary *)dictionary {
}


@end
