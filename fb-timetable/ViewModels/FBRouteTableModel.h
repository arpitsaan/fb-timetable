//
//  FBRouteTableModel.h
//  fb-timetable
//
//  Created by Arpit Agarwal on 18/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBRouteSectionModel.h"
#import "FBRouteTimetable.h"

@interface FBRouteTableModel : NSObject

@property(nonatomic, strong) NSArray<FBRouteSectionModel *> *arrivalSections;
@property(nonatomic, strong) NSArray<FBRouteSectionModel *> *departureSections;

- (void)setRouteTimetable:(FBRouteTimetable *)timeTable;

@end
