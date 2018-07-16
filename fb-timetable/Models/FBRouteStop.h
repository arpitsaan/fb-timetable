//
//  FBRouteStop.h
//  fb-timetable
//
//  Created by Arpit Agarwal on 16/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBModelObject.h"
#import "FBDateTime.h"
#import "FBStation.h"

@interface FBRouteStop : FBModelObject

@property (nonatomic, strong) NSString *direction;
@property (nonatomic, strong) NSString *lineCode;
@property (nonatomic, strong) NSString *lineDirection;
@property (nonatomic, strong) NSNumber *rideId;
@property (nonatomic, strong) NSString *tripUid;
@property (nonatomic, strong) NSString *throughStations;
@property (nonatomic, strong) NSArray <FBStation *> *route;
@property (nonatomic, strong) FBDateTime *timeObj;

@end
