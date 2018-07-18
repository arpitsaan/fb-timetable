//
//  FBRouteSectionModel.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 18/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBRouteSectionModel.h"

@implementation FBRouteSectionModel

- (instancetype)initWithArray:(NSArray <FBRouteStop *>*)routeStops {
    self = [super init];
    
    if (self) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (FBRouteStop *routeStope in routeStops) {
            FBRouteCellModel *cellVM = [[FBRouteCellModel alloc] initWithRouteStop:routeStope];
            [tempArray addObject:cellVM];
        }
        self.sectionCells = tempArray;
    }
    
    return self;
}

@end
