//
//  FBCommonHelpers.h
//  fb-timetable
//
//  Created by Arpit Agarwal on 18/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBCommonHelpers : NSObject

+ (NSString *)get24HourStringWithTimestamp:(NSNumber *)timestamp timezone:(NSString *)timezone;
+ (NSString *)getDateStringWithTimestamp:(NSNumber *)timestamp timezone:(NSString *)timezone;

@end
