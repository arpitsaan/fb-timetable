//
//  FBRouteCellModel.h
//  fb-timetable
//
//  Created by Arpit Agarwal on 18/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBRouteStop.h"

@interface FBRouteCellModel : NSObject

@property(nonatomic, strong) NSString *highlightText;
@property(nonatomic, strong) NSString *titleText;
@property(nonatomic, strong) NSString *subtitleText;
@property(nonatomic, strong) NSString *accessoryText;

- (instancetype)initWithRouteStop:(FBRouteStop *)routeStop;

@end
