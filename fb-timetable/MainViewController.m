//
//  MainViewController.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+AutoLayout.h"
#import "FBRouteTimetable.h"

@interface MainViewController() <FBRouteTimetableDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) FBRouteTimetable *timetableObject;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self getData];
}

- (void)getData {
    self.timetableObject = [[FBRouteTimetable alloc] init];
    [self.timetableObject getFBRouteTimetable:self];
}

- (void)createViews {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [self.view setBackgroundColor:[UIColor yellowColor]];
    [self.tableView setBackgroundColor:[UIColor blueColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)routeTimetableDownloadFailedWithError:(NSError *)error {
    
}

- (void)routeTimetableDownloadedSuccessfully {
    asdf
}


@end
