//
//  FBDateTime.h
//  fb-timetable
//
//  Created by Arpit Agarwal on 16/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBModelObject.h"

@interface FBDateTime : FBModelObject

@property (nonatomic, strong) NSNumber *timestamp;
@property (nonatomic, strong) NSString *timezone;

@end
