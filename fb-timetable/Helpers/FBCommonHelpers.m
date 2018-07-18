//
//  FBCommonHelpers.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 18/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBCommonHelpers.h"

@implementation FBCommonHelpers

+ (NSString *)get24HourStringWithTimestamp:(NSNumber *)timestamp timezone:(NSString *)timezone {
    
    //FIXME - move to background thread after parsing
    NSDate *dateObj = [NSDate dateWithTimeIntervalSince1970:timestamp.integerValue];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:timezone];
    [timeFormatter setTimeZone:tz];
    
    //FIXME - improve this, maybe try catch
    NSString *timingString = [timeFormatter stringFromDate:dateObj];
    return timingString;
}

+ (NSString *)getDateStringWithTimestamp:(NSNumber *)timestamp timezone:(NSString *)timezone {
 
    //FIXME - move to background thread after parsing
    NSDate *dateObj = [NSDate dateWithTimeIntervalSince1970:timestamp.integerValue];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"EEEE, MMM d"];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:timezone];
    [timeFormatter setTimeZone:tz];

    NSString *timingString = [timeFormatter stringFromDate:dateObj];
    
    //add prefix for today/tomorrow
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [cal setTimeZone:tz];
    
    if ([cal isDateInToday:dateObj]) {
        //today
        timingString = [NSString stringWithFormat:@"Today · %@", timingString];
    } else if ([cal isDateInTomorrow:dateObj]) {
        //tomorrow
        timingString = [NSString stringWithFormat:@"Tomorrow · %@", timingString];
    }
    
    //FIXME - improve this, maybe try catch
    return timingString;
}
@end
