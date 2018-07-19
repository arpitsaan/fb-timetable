//
//  FBSplashView.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 19/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBSplashView.h"
#import "UIColor+Hex.h"

@interface FBSplashView ()
@property (nonatomic, strong) UIImageView *topArrowView;
@property (nonatomic, strong) UIImageView *bottomArrowView;
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation FBSplashView

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    if (self) {
        [self setupDefaults];
        [self createViews];
    }
    
    return self;
}

- (void)setupDefaults{
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)createViews {
    self.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.backgroundView setBackgroundColor:[UIColor colorWithHex:0x8EEF0A]];
    [self addSubview:self.backgroundView];
    
    self.topArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 450, 450)];
    [self.topArrowView setContentMode:UIViewContentModeScaleAspectFit];
    [self.topArrowView setImage:[UIImage imageNamed:@"top-arrow-image"]];
    [self addSubview:self.topArrowView];
    
    [self.topArrowView setCenter:CGPointMake(self.center.x - 84, self.center.y - 70)];
    
    self.bottomArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 450, 450)];
    [self.bottomArrowView setContentMode:UIViewContentModeScaleAspectFit];
    [self.bottomArrowView setImage:[UIImage imageNamed:@"bottom-arrow-image"]];
    [self addSubview:self.bottomArrowView];
    [self.bottomArrowView setCenter:self.center];
    
    [self.bottomArrowView setCenter:CGPointMake(self.center.x + 84, self.center.y + 70)];
}

- (void)playAnimationOnWindow {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    CGFloat kTransform = self.frame.size.width;
    
    //go apart
    [self.topArrowView setAlpha:1.0f];
    [self.bottomArrowView setAlpha:1.0f];
    
    [self.topArrowView setTransform:CGAffineTransformMakeTranslation(-kTransform, 0.0f)];
    [self.bottomArrowView setTransform:CGAffineTransformMakeTranslation(+kTransform, 0.0f)];
    
    CGFloat delay = 0;
    
    //come together
    [UIView animateWithDuration:1.5f delay:delay usingSpringWithDamping:1.0f initialSpringVelocity:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.topArrowView setTransform:CGAffineTransformMakeTranslation(0, 0.0f)];
        [self.bottomArrowView setTransform:CGAffineTransformMakeTranslation(0, 0.0f)];
    } completion:^(BOOL finished) {
        
    }];
    
    delay += 1.0f;
    
    //slow move
    [UIView animateWithDuration:3.4f delay:delay usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
        [self.topArrowView setTransform:CGAffineTransformMakeTranslation(30, 0.0f)];
        [self.bottomArrowView setTransform:CGAffineTransformMakeTranslation(-30, 0.0f)];
    } completion:^(BOOL finished) {

    }];
    
    delay += 2.7f;
    
    //arrows exit
    [UIView animateWithDuration:1.0f delay:delay usingSpringWithDamping:1.0f initialSpringVelocity:0.1f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        [self.topArrowView setTransform:CGAffineTransformMakeTranslation(kTransform*2, 0.0f)];
        [self.bottomArrowView setTransform:CGAffineTransformMakeTranslation(-kTransform*2, 0.0f)];
        [self.topArrowView setAlpha:0.0f];
        [self.bottomArrowView setAlpha:0.0f];
        [self.backgroundView setAlpha:0.0];
        
    } completion:^(BOOL finished) {
        
        //done
        [self removeFromSuperview];
    }];
}

@end
