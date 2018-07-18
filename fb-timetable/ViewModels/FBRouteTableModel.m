//
//  FBRouteTableModel.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 18/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBRouteTableModel.h"

@implementation FBRouteTableModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.arrivalSections = [[NSMutableArray alloc] init];
        self.departureSections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setRouteTimetable:(FBRouteTimetable *)timeTable {
    self.arrivalSections  = [self getSectionsArrayWithRouteStops:timeTable.arrivals];
}

- (NSArray *)getSectionsArrayWithRouteStops:(NSArray <FBRouteStop *>*)routeStops {
    NSMutableArray *tempMainArray = [[NSMutableArray alloc] init];
    
    NSDate *tempDate = nil;
    NSMutableArray *tempCurrentSectionArray = [[NSMutableArray alloc] init];
    
    for (FBRouteStop *currentStop in routeStops) {
        //get stop from array
        NSDate *arrivalDate = [NSDate dateWithTimeIntervalSince1970:currentStop.timeObj.timestamp.integerValue];
        
        //compare with previous stop's date
        if (tempDate == nil) {
            //first stop - add to array
            tempDate = arrivalDate;
            [tempCurrentSectionArray addObject:currentStop];
            
        } else {
            NSTimeZone *timezone = [NSTimeZone timeZoneWithName:currentStop.timeObj.timezone];
            NSCalendar *cal = [NSCalendar currentCalendar];
            [cal setTimeZone:timezone];
            
            //compare with calendar
            NSComparisonResult result = [cal isDate:arrivalDate inSameDayAsDate:tempDate];

            if (result == NSOrderedSame || tempDate == nil) {
                //same date
                [tempCurrentSectionArray addObject:currentStop];
            }else {
                //different date - add section to main array
                [tempMainArray addObject:[[FBRouteSectionModel alloc] initWithArray:tempCurrentSectionArray]];
                tempDate = nil;
            }
        }
    }
    
    return tempMainArray;
}

@end
