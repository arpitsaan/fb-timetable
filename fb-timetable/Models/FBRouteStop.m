//
//  FBRouteStop.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 16/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBRouteStop.h"

@interface FBRouteStop()
@property(nonatomic, strong) NSMutableArray *tempRoute;
@end

@implementation FBRouteStop

- (void)parseObject:(NSDictionary *)responseObject withInitialParams:(NSDictionary *)params {

    //trip uid
    self.tripUid = [self getStringForKey:@"trip_uid" fromDictionary:responseObject withInitialValue:self.tripUid];

    //through the stations
    self.throughStations = [self getStringForKey:@"through_the_stations" fromDictionary:responseObject withInitialValue:self.throughStations];
    
    //line code
    self.lineCode = [self getStringForKey:@"line_code" fromDictionary:responseObject withInitialValue:self.lineCode];
    
    //direction string
    self.direction = [self getStringForKey:@"direction" fromDictionary:responseObject withInitialValue:self.direction];
    
    //line code
    self.lineCode = [self getStringForKey:@"line_code" fromDictionary:responseObject withInitialValue:self.lineCode];
    
    //datetime
    if([responseObject valueForKey:@"datetime"] != nil) {
        [self.timeObj parseObject:[responseObject valueForKey:@"datetime"] withInitialParams:params];
    }
    
    //route
    self.tempRoute = [[NSMutableArray alloc] init];
    for (NSDictionary *stationDict in [responseObject valueForKeyPath:@"route"]) {
        FBStation *tempStation = [[FBStation alloc] init];
        [tempStation parseObject:stationDict withInitialParams:params];
        [self.tempRoute addObject:stationDict];
    }
}

@end
