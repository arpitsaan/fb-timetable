//
//  FBRouteTimetable.h
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBModelObject.h"
#import "FBStation.h"
#import "FBRouteStop.h"

@protocol FBRouteTimetableDelegate <NSObject>
- (void)routeTimetableDownloadedSuccessfully;
- (void)routeTimetableDownloadFailedWithError:(NSError *)error;
@end

@interface FBRouteTimetable : FBModelObject

@property(nonatomic, weak) id<FBRouteTimetableDelegate> delegate;

@property(nonatomic, strong) NSArray *departures;
@property(nonatomic, strong) NSArray *arrivals;
@property(nonatomic, strong) FBStation *stationInfo;

@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *message;

- (void)getFBRouteTimetable:(id<FBRouteTimetableDelegate>)delegate;

@end

/*"route": [
 {
 "id": 984,
 "name": "Göhren Rügen",
 "default_address": {
 "address": "Bahnhofstraße 1",
 "full_address": "Bahnhofstraße 1, 18586 Göhren, Germany",
 "coordinates": {
 "latitude": 54.345715,
 "longitude": 13.738117
 }
 },
 "address": "Bahnhofstraße 1",
 "full_address": "Bahnhofstraße 1, 18586 Göhren, Germany",
 "coordinates": {
 "latitude": 54.345715,
 "longitude": 13.738117
 }
 */
