//
//  FBRouteStopTableViewCell.h
//  fb-timetable
//
//  Created by Arpit Agarwal on 18/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBRouteCellModel.h"

@interface FBRouteStopTableViewCell : UITableViewCell

@property(nonatomic, strong) NSString *titleText;
@property(nonatomic, strong) NSString *subtitleText;
@property(nonatomic, strong) NSString *accessoryText;
@property(nonatomic, strong) NSString *highlighterText;
@property(nonatomic, strong) UIImage *iconImage;

@end
