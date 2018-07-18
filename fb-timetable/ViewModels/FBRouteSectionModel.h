//
//  FBRouteSectionModel.h
//  fb-timetable
//
//  Created by Arpit Agarwal on 18/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBRouteCellModel.h"

@interface FBRouteSectionModel : NSObject

@property(nonatomic, strong) NSString *sectionTitle;
@property(nonatomic, strong) NSString *sectionSubtitle;
@property(nonatomic, strong) NSNumber *sectionScrollOffset;

@property(nonatomic, strong) NSArray <FBRouteCellModel *> *sectionCells;

- (instancetype)initWithArray:(NSArray<FBRouteStop *>*)routeStops;

@end
