//
//  FBRouteTimetable.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBRouteTimetable.h"
#import "FBApiManager.h"

@interface FBRouteTimetable()
@property (nonatomic, strong) NSMutableArray *tempArrivals;
@property (nonatomic, strong) NSMutableArray *tempDepartures;

@end

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
    
    self.tempArrivals = [[NSMutableArray alloc] init];
    self.tempDepartures = [[NSMutableArray alloc] init];
    
    for (NSDictionary *routeStopDict in [responseObject valueForKeyPath:@"timetable.arrivals"]) {
        FBRouteStop *arrivalStop = [[FBRouteStop alloc] init];
        [arrivalStop parseObject:routeStopDict withInitialParams:params];
        [self.tempArrivals addObject:arrivalStop];
    }
    
    for (NSDictionary *routeStopDict in [responseObject valueForKeyPath:@"timetable.departures"]) {
        FBRouteStop *departureStop = [[FBRouteStop alloc] init];
        [departureStop parseObject:routeStopDict withInitialParams:params];
        [self.tempDepartures addObject:departureStop];
    }
}

- (void)didFetchObjects:(id)objects ForClass:(Class)klass withInitialParams:(NSDictionary *)params {

    //update departures array
    if (self.tempDepartures.count > 0) {
        self.departures = [NSArray arrayWithArray:self.tempDepartures];
    }
    
    //update arrivals array
    if (self.tempArrivals.count > 0) {
        self.arrivals = [NSArray arrayWithArray:self.tempArrivals];
    }
    
    //replace arrivals array
    if ([self.delegate respondsToSelector:@selector(routeTimetableDownloadedSuccessfully)]) {
        [self.delegate routeTimetableDownloadedSuccessfully];
    }
    
}

- (void)didFailForClass:(Class)klass withError:(NSError *)error andInitialParams:(NSDictionary *)dictionary {
    
    if ([self.delegate respondsToSelector:@selector(routeTimetableDownloadFailedWithError:)]) {
        [self.delegate routeTimetableDownloadFailedWithError:error];
    }
}

@end
