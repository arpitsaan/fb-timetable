//
//  fb_timetableTests.m
//  fb-timetableTests
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FBCommonHelpers.h"

@interface fb_timetableTests : XCTestCase

@end

@implementation fb_timetableTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGet24HourStringWithTimestampReturnsCorrectDisplayTimeString {
    //    1532032800, GMT+02:00 -> 22:40
    NSString *timeString = [FBCommonHelpers get24HourStringWithTimestamp:@(1532032800) timezone:@"GMT+02:00"];
    XCTAssertTrue([timeString isEqualToString:@"22:40"]);
}

- (void)testGet24HourStringWithTimestampReturnsTimeZero {
    //    0, GMT -> 00:00
    NSString *timeString = [FBCommonHelpers get24HourStringWithTimestamp:@(0) timezone:@"GMT"];
    XCTAssertTrue([timeString isEqualToString:@"00:00"]);
}

- (void)testGet24HourStringWithTimestampReturnsCorrectTimeInTimezone {
    //    0, GMT -> 05:30
    NSString *timeString = [FBCommonHelpers get24HourStringWithTimestamp:@(0) timezone:@"GMT+5:30"];
    XCTAssertTrue([timeString isEqualToString:@"05:30"]);
    
}

- (void)testGetDateStringWithTimestampPrefixesToday {
    NSTimeInterval today = [[NSDate date] timeIntervalSince1970];
    NSNumber *todayObj = [NSNumber numberWithDouble:today];
    NSString *timeString = [FBCommonHelpers getDateStringWithTimestamp:todayObj timezone:@""];
    
    XCTAssertTrue([timeString hasPrefix:@"Today"]);
}

- (void)testGetDateStringWithTimestampDoesNotPrefixTodayWhenTimestampIsZero {
    NSString *timeString = [FBCommonHelpers getDateStringWithTimestamp:@(0) timezone:@"GMT"];
    
    XCTAssertFalse([timeString hasPrefix:@"Today"]);
}

- (void)testGetDateStringWithTimestampDoestNotPrefixsTomorrowForToday {
    NSTimeInterval today = [[NSDate date] timeIntervalSince1970];
    NSNumber *todayObj = [NSNumber numberWithDouble:today];
    NSString *timeString = [FBCommonHelpers getDateStringWithTimestamp:todayObj timezone:@""];
    
    XCTAssertFalse([timeString hasPrefix:@"Tomorrow"]);
}

- (void)testGetDateStringWithTimestampPrefixesTomorrow {
    NSDate *tomorrowsDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
    NSTimeInterval tomorrow = [tomorrowsDate timeIntervalSince1970];
    NSNumber *tomorrowObj = [NSNumber numberWithDouble:tomorrow];
    NSString *timeString = [FBCommonHelpers getDateStringWithTimestamp:tomorrowObj timezone:@""];
    
    XCTAssertTrue([timeString hasPrefix:@"Tomorrow"]);
}

- (void)testGetDateStringWithTimestampDoesNotPrefixTomorrowWhenTimestampIsZero {
    NSString *timeString = [FBCommonHelpers getDateStringWithTimestamp:@(0) timezone:@"GMT"];
    
    XCTAssertFalse([timeString hasPrefix:@"Tomorrow"]);
}

/*
 Performance Measurement
 */
- (void)testPerformanceOfGet24HourStringWithTimestamp {
    [self measureBlock:^{
        [FBCommonHelpers get24HourStringWithTimestamp:@(1532032800) timezone:@"GMT+02:00"];
    }];
}

@end























