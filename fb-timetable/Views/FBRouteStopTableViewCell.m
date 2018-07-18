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
@property(nonatomic, strong) UILabel *highlighterLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subtitleLabel;
@property(nonatomic, strong) UILabel *accessoryLabel;
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
    //highlighter label
    self.highlighterLabel = [[UILabel alloc] init];
    [self.highlighterLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightBold]];
    [self.highlighterLabel setTextColor:[UIColor colorWithHex:0x57A300]];
    [self.contentView addSubview:self.highlighterLabel];
    
    //title label
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setFont: [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold]];
    [self.titleLabel setText:@"Station of the Bus"];
    [self.titleLabel setNumberOfLines:0];
    [self.contentView addSubview:self.titleLabel];
    
    //subtitle label
    self.subtitleLabel = [[UILabel alloc] init];
     [self.subtitleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular]];
    [self.subtitleLabel setTextColor:UIColor.grayColor];
    [self.subtitleLabel setNumberOfLines:0];
    [self.subtitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:self.subtitleLabel];
    
    //accessory label
    self.accessoryLabel = [[UILabel alloc] init];
    [self.accessoryLabel setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold]];
    [self.contentView addSubview:self.accessoryLabel];
}

- (void)setConstraints {
    //constants
    CGFloat padding = 15.0f;
    
    //highlighter label
    [self.highlighterLabel setTopView:self.contentView constant:padding];
    [self.highlighterLabel setLeadingView:self.contentView constant:padding];
    [self.highlighterLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.highlighterLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    //title label
    [self.titleLabel setBelowView:self.highlighterLabel constant:2.0f];
    [self.titleLabel setLeadingView:self.highlighterLabel];
    [self.titleLabel setBeforeView:self.accessoryLabel];
    
    //subtitle label
    [self.subtitleLabel setBelowView:self.titleLabel constant:2.0f];
    [self.subtitleLabel setSameLeadingTrailingView:self.titleLabel];
    [self.subtitleLabel setBottomView:self.contentView constant:padding];
    
    //accessory label
    [self.accessoryLabel setCenterYView:self.contentView];
    [self.accessoryLabel setTrailingView:self.contentView constant:padding];
    [self.accessoryLabel setTextAlignment:NSTextAlignmentRight];
    [self.accessoryLabel setViewWidth:70.0f];
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    [self.titleLabel setText:_titleText];
    [self layoutIfNeeded];
}

- (void)setSubtitleText:(NSString *)subtitleText {
    _subtitleText = subtitleText;
    [self.subtitleLabel setText:_subtitleText];
    [self layoutIfNeeded];
}

- (void)setAccessoryText:(NSString *)accessoryText {
    _accessoryText = accessoryText;
    [self.accessoryLabel setText:_accessoryText];
    [self layoutIfNeeded];
}

- (void)setHighlighterText:(NSString *)highlighterText {
    _highlighterText = highlighterText;
    [self.highlighterLabel setText:_highlighterText];
    [self layoutIfNeeded];
}

@end
