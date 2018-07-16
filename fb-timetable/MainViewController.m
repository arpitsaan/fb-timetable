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

@interface MainViewController() <FBRouteTimetableDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UISegmentedControl *segmentControl;
@property(nonatomic, strong) FBRouteTimetable *timetableObj;
@property(nonatomic, strong) NSArray *currentlyShowingData;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self getData];
}

- (void)getData {
    self.timetableObj = [[FBRouteTimetable alloc] init];
    [self.timetableObj getFBRouteTimetable:self];
    self.navigationItem.title = @"Loading data...";
}

- (void)createViews {
    [self createSegmentedControl];
    [self createTableView];
    [self.view bringSubviewToFront:self.segmentControl];
}

- (void)createSegmentedControl {
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Arrivals", @"Departure", nil]];
    [self.segmentControl setBackgroundColor:UIColor.whiteColor];

//    [self.segmentControl setTitle:@"Arrivals" forSegmentAtIndex:0];
    [self.view addSubview:self.segmentControl];
    [self.segmentControl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(100, 0, 0, 0) excludingEdge:ALEdgeBottom];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] init];
//    [self.tableView setDataSource:self];
//    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.segmentControl];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
}

#pragma mark - FBRouteTimetableDelegate methods
- (void)routeTimetableDownloadFailedWithError:(NSError *)error {
    self.navigationItem.title = [NSString stringWithFormat:@"Error! [%@]", error.description];
}

- (void)routeTimetableDownloadedSuccessfully {
    [self.tableView reloadData];
    self.navigationItem.title = @"Data =";
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timetableObj.arrivals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"CellReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    FBRouteStop *routeStop = [self.timetableObj.arrivals objectAtIndex:indexPath.row];
    [cell.textLabel setText:routeStop.direction];
    [cell.detailTextLabel setText:routeStop.throughStations];
    
    return cell;
}

@end
