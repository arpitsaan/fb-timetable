//
//  FBStation.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBStation.h"

@implementation FBStation

- (void)parseObject:(NSDictionary *)responseObject withInitialParams:(NSDictionary *)params {
    self.stationId = [self getNumberForKey:@"id" fromDictionary:responseObject withInitialValue:self.stationId];
    
    self.name = [self getStringForKey:@"name" fromDictionary:responseObject withInitialValue:self.name];
    
    self.shortAddress = [self getStringForKey:@"address" fromDictionary:responseObject withInitialValue:self.shortAddress];

    self.fullAddress = [self getStringForKey:@"name" fromDictionary:responseObject withInitialValue:self.fullAddress];
}

@end
