//
//  FBStation.h
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBModelObject.h"
#import "FBCoordinate.h"

@interface FBStation : FBModelObject

@property(nonatomic, strong) NSNumber *stationId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *shortAddress;
@property(nonatomic, strong) NSString *fullAddress;
@property(nonatomic, strong) FBCoordinate *coordinates;

@end
