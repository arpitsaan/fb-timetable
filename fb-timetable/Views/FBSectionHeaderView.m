//
//  FBSectionHeaderView.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 18/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBSectionHeaderView.h"
#import "UIView+AutoLayout.h"
#import "UIColor+Hex.h"

@interface FBSectionHeaderView()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subtitleLabel;
@property(nonatomic, strong) UIView *bottomSeparator;
@end

@implementation FBSectionHeaderView

- (instancetype)init {
    self = [super init];
    if(self) {
        [self setupDefaults];
        [self createViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupDefaults {
    self.backgroundColor = [UIColor colorWithHex:0xF7F7F4];
}

- (void)createViews {
    //title
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightBold]];
    [self addSubview:self.titleLabel];
    
    //subtitle
    self.subtitleLabel = [[UILabel alloc] init];
    [self.subtitleLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium]];
    [self.subtitleLabel setTextColor:UIColor.darkGrayColor];
    [self addSubview:self.subtitleLabel];
    
    //separator
    self.bottomSeparator = [[UIView alloc] init];
    [self.bottomSeparator setBackgroundColor:[UIColor colorWithHex:0xEFEFEF]];
    [self addSubview:self.bottomSeparator];
}

- (void)setupConstraints {
    //constants
    CGFloat padding = 15.0f;
    
    //title
    [self.titleLabel setTopView:self constant:padding];
    [self.titleLabel setLeadingView:self constant:padding];
    
    //subtitle
    [self.subtitleLabel setBelowView:self.titleLabel constant:2];
    [self.subtitleLabel setBottomView:self constant:padding];
    [self.subtitleLabel setSameLeadingTrailingView:self.titleLabel];
    
    //separator
    [self.bottomSeparator setBottomView:self];
    [self.bottomSeparator setSameLeadingTrailingView:self];
    [self.bottomSeparator setViewHeight:1.0f];
}

- (void)setTitleText:(NSString *)titleText subtitleText:(NSString *)subtitle{
    [self.titleLabel setText:titleText];
    [self.subtitleLabel setText:subtitle];
}

@end
