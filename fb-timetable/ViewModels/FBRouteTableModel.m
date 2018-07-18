//
//  FBRouteTableModel.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 18/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBRouteTableModel.h"
#import "FBCommonHelpers.h"

@implementation FBRouteTableModel

#pragma mark - Init Method
- (instancetype)init {
    self = [super init];
    if (self) {
        self.arrivalSections = [[NSMutableArray alloc] init];
        self.departureSections = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Setters
- (void)setRouteTimetable:(FBRouteTimetable *)timeTable {
    self.headerTitle = timeTable.stationInfo.name;
    self.arrivalSections  = [self getSectionsArrayWithRouteStops:timeTable.arrivals];
    self.departureSections  = [self getSectionsArrayWithRouteStops:timeTable.departures];
}


#pragma mark - Helpers
/*
 This method iterates over all the route stops and segments the array into multiple parts based on timestamp. Every route stop timing is compared with the previous one in the array and based on this comparison, it is grouped with the previous route stop.
 */
- (NSArray *)getSectionsArrayWithRouteStops:(NSArray <FBRouteStop *>*)routeStops {
    NSMutableArray *tempMainArray = [[NSMutableArray alloc] init];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *previousDate = nil;
    NSMutableArray *currentSectionArray = [[NSMutableArray alloc] init];
    BOOL islastSectionAdded = NO;
    
    for (FBRouteStop *tempStop in routeStops) {
        
        //iterate over route stop
        NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:tempStop.timeObj.timestamp.integerValue];
        
        //compare with previous stop's date
        if (previousDate == nil) {
            //first stop - add to array
            previousDate = tempDate;
            [currentSectionArray addObject:tempStop];
            islastSectionAdded = NO;
        } else {
            NSTimeZone *timezone = [NSTimeZone timeZoneWithName:tempStop.timeObj.timezone];
            [cal setTimeZone:timezone];
            
            //compare with previous route stop date
            BOOL isSameDay = [cal isDate:tempDate inSameDayAsDate:previousDate];

            if (isSameDay) {
                //same date
                [currentSectionArray addObject:tempStop];
                islastSectionAdded = NO;
            }else {
                //date didn't match with current
                [tempMainArray addObject:[self getSectionModelObjWithRoutesArray:currentSectionArray]];
                
                //reset values
                [currentSectionArray removeAllObjects];
                previousDate = nil;
                islastSectionAdded = YES;
            }
        }
    }
    
    //for the last section of dates
    if (!islastSectionAdded) {
        [tempMainArray addObject:[self getSectionModelObjWithRoutesArray:currentSectionArray]];
    }
    
    //done, return.
    return tempMainArray;
}

/*
 Returns a section view model object when an array of route stops is passed.
 */
- (FBRouteSectionModel *)getSectionModelObjWithRoutesArray:(NSArray <FBRouteStop *>*)array {
    FBRouteSectionModel *sectionDataObj = [[FBRouteSectionModel alloc] initWithArray:array];
    FBRouteStop *firstStop = [array firstObject];
    sectionDataObj.sectionTitle = [FBCommonHelpers getDateStringWithTimestamp:firstStop.timeObj.timestamp timezone:firstStop.timeObj.timezone];
    
    return sectionDataObj;
}


@end
