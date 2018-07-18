//
//  FBRouteCellModel.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 18/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBRouteCellModel.h"
#import "FBCommonHelpers.h"

@implementation FBRouteCellModel

- (instancetype)initWithRouteStop:(FBRouteStop *)routeStop {
    self = [super init];
    
    if (self) {
        self.highlightText = routeStop.lineCode;
        self.titleText = routeStop.lineDirection;
        self.subtitleText = routeStop.throughStations;
        
        self.accessoryText = [FBCommonHelpers get24HourStringWithTimestamp:routeStop.timeObj.timestamp timezone:routeStop.timeObj.timezone];
    }
    
    return self;
}

@end
