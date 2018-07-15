//
//  FBCoordinate.h
//  fb-timetable
//
//  Created by zom on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBModelObject.h"

@interface FBCoordinate : FBModelObject

@property(nonatomic, strong) NSNumber *latitude;
@property(nonatomic, strong) NSNumber *longitude;

@end
