//
//  FBRouteStopTableViewCell.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 18/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBRouteStopTableViewCell.h"
#import "UIView+AutoLayout.h"
#import "UIColor+Hex.h"

@interface FBRouteStopTableViewCell()
@property(nonatomic, strong) UILabel *lineCodeLabel;
@property(nonatomic, strong) UILabel *directionLabel;
@property(nonatomic, strong) UILabel *routeDetailsLabel;
@property(nonatomic, strong) UILabel *timingLabel;
@end

@implementation FBRouteStopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createViews];
        [self setConstraints];
    }
    return self;
}

#pragma mark - Create Views
- (void)createViews {
    //line code label
    self.lineCodeLabel = [[UILabel alloc] init];
    [self.lineCodeLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
//    [self.lineCodeLabel setBackgroundColor:[UIColor colorWithHex:0x73D700]];
//    [self.lineCodeLabel setTextColor:[UIColor whiteColor]];
    [self.lineCodeLabel setTextColor:[UIColor colorWithHex:0x57A300]];
    [self.contentView addSubview:self.lineCodeLabel];
    
    //direction label
    self.directionLabel = [[UILabel alloc] init];
    [self.directionLabel setFont: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.directionLabel setText:@"Station of the Bus"];
    [self.directionLabel setNumberOfLines:0];
    [self.contentView addSubview:self.directionLabel];
    
    //route details label
    self.routeDetailsLabel = [[UILabel alloc] init];
    [self.routeDetailsLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]];
    [self.routeDetailsLabel setTextColor:UIColor.grayColor];
    [self.routeDetailsLabel setNumberOfLines:0];
    [self.routeDetailsLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:self.routeDetailsLabel];
    
    //timing label
    self.timingLabel = [[UILabel alloc] init];
    [self.timingLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.contentView addSubview:self.timingLabel];
}

- (void)setConstraints {
    //constants
    CGFloat padding = 15.0f;
    
    //line code label
    [self.lineCodeLabel setTopView:self.contentView constant:padding];
    [self.lineCodeLabel setLeadingView:self.contentView constant:padding];
    [self.lineCodeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.lineCodeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    //direction label
    [self.directionLabel setBelowView:self.lineCodeLabel constant:2.0f];
    [self.directionLabel setLeadingView:self.lineCodeLabel];
    [self.directionLabel setBeforeView:self.timingLabel];
    
    //route details label
    [self.routeDetailsLabel setBelowView:self.directionLabel constant:2.0f];
    [self.routeDetailsLabel setSameLeadingTrailingView:self.directionLabel];
    [self.routeDetailsLabel setBottomView:self.contentView];
    
    //timings label
    [self.timingLabel setCenterYView:self.contentView];
    [self.timingLabel setTrailingView:self.contentView constant:padding];
    [self.timingLabel setTextAlignment:NSTextAlignmentRight];
    [self.timingLabel setViewWidth:60.0f];
}

- (void)setRouteStop:(FBRouteStop *)routeStop {
    //FIXME - move to background thread during parsing
    NSDate *dateObj = [NSDate dateWithTimeIntervalSince1970:routeStop.timeObj.timestamp.integerValue];
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter3 setDateFormat:@"HH:mm"];
    NSString *timingString = [dateFormatter3 stringFromDate:dateObj];
    
    [self.lineCodeLabel setText:routeStop.lineCode];
    [self.directionLabel setText:routeStop.direction];
    [self.routeDetailsLabel setText:routeStop.throughStations];
    [self.timingLabel setText:timingString];
    
    [self layoutIfNeeded];
}

@end
