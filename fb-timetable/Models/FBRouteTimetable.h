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

@property(nonatomic, strong) NSArray<FBRouteStop *> *departures;
@property(nonatomic, strong) NSArray<FBRouteStop *> *arrivals;
@property(nonatomic, strong) FBStation *stationInfo;

- (void)getFBRouteTimetableForCityId:(NSNumber *)cityId delegate:(id<FBRouteTimetableDelegate>)delegate;

- (void)cleanUpData;

@end
