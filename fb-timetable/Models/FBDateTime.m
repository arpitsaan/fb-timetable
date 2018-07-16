//
//  FBDateTime.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 16/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBDateTime.h"

@implementation FBDateTime

- (void)parseObject:(NSDictionary *)responseObject withInitialParams:(NSDictionary *)params {
    self.timestamp = [self getNumberForKey:@"timestamp" fromDictionary:responseObject withInitialValue:self.timestamp];
    self.timezone = [self getStringForKey:@"tz" fromDictionary:responseObject withInitialValue:self.timezone];
}

@end
