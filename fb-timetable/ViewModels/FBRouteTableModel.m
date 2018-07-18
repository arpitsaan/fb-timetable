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
    
    NSDate *previousDate = nil;
    NSMutableArray *currentSectionArray = [[NSMutableArray alloc] init];
    BOOL lastStopAdded = NO;
    
    for (FBRouteStop *tempStop in routeStops) {
//        NSLog(@"\n\n%@, %ld", tempStop.timeObj.timestamp, (long)count++);
        //get stop from array
        NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:tempStop.timeObj.timestamp.integerValue];
        
        //compare with previous stop's date
        if (previousDate == nil) {
            //first stop - add to array
            previousDate = tempDate;
            [currentSectionArray addObject:tempStop];
//            NSLog(@"%@, %ld - prev nil", tempStop.timeObj.timestamp, (long)count);
            lastStopAdded = NO;
        } else {
//            NSLog(@"%@, %ld - prev non nil", tempStop.timeObj.timestamp, (long)count);
            NSTimeZone *timezone = [NSTimeZone timeZoneWithName:tempStop.timeObj.timezone];
            NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            [cal setTimeZone:timezone];
            
            //compare with calendar
            BOOL isSameDay = [cal isDate:tempDate inSameDayAsDate:previousDate];

            if (isSameDay) {
//                NSLog(@"%@, %ld - same day", tempStop.timeObj.timestamp, (long)count);
                //same date
                [currentSectionArray addObject:tempStop];
                lastStopAdded = NO;
            }else {
                //different date
                FBRouteSectionModel *sectionDataObj = [[FBRouteSectionModel alloc] initWithArray:currentSectionArray];
                sectionDataObj.sectionTitle = [FBCommonHelpers getDateStringWithTimestamp:tempStop.timeObj.timestamp timezone:tempStop.timeObj.timezone];
                
//                NSLog(@"%@, %ld - different day - count %lu\n--------------------------\n", tempStop.timeObj.timestamp, (long)count,(unsigned long)currentSectionArray.count);
                
                [tempMainArray addObject:sectionDataObj];
                [currentSectionArray removeAllObjects];
                previousDate = nil;
                lastStopAdded = YES;
            }
        }
    }
    
    if (!lastStopAdded) {
        FBRouteSectionModel *sectionDataObj = [[FBRouteSectionModel alloc] initWithArray:currentSectionArray];
        FBRouteStop *stop = [currentSectionArray lastObject];
        sectionDataObj.sectionTitle = [FBCommonHelpers getDateStringWithTimestamp:stop.timeObj.timestamp timezone:stop.timeObj.timezone];
        [tempMainArray addObject:sectionDataObj];
    }
    
    return tempMainArray;
}

@end
