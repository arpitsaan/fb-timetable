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
#import "FBRouteStopTableViewCell.h"
#import "UIColor+Hex.h" //FIXME - Add in Constant of PCH file.

@interface MainViewController() <FBRouteTimetableDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UISegmentedControl *segmentControl;
@property(nonatomic, strong) FBRouteTimetable *timetableObj;
@property(nonatomic, strong) NSArray *currentlyShowingData;

@end

typedef NS_ENUM( NSInteger, FBSegment ) {
    FBSegmentArrivals = 0,
    FBSegmentDepartures = 1
};

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefaults];
    [self createViews];
    [self getData];
}

- (void)setupDefaults {
    self.currentlyShowingData = [[NSArray alloc] init];
    [self.view setBackgroundColor:UIColor.whiteColor];
    
    //navigation headr
    self.navigationItem.title = @"Loading data...";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:0x73D700]];
}

- (void)getData {
    self.timetableObj = [[FBRouteTimetable alloc] init];
    [self.timetableObj getFBRouteTimetable:self];
    
}

- (void)createViews {
    [self createSegmentedControl];
    [self createTableView];
    [self.view bringSubviewToFront:self.segmentControl];
}

- (void)createSegmentedControl {
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Arrivals", @"Departure", nil]];
    UIFont *font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentControl setTitleTextAttributes:attributes                                    forState:UIControlStateNormal];

    [self.segmentControl setBackgroundColor:UIColor.whiteColor];
    [self.segmentControl setSelectedSegmentIndex:FBSegmentArrivals];
    [self.segmentControl addTarget:self action:@selector(didTapSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentControl];
    [self.segmentControl setTintColor:[UIColor colorWithHex:0x73D700]];
    
    //set constraints
    if (@available(iOS 11.0, *)) {
        UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.segmentControl.topAnchor constraintEqualToAnchor:safe.topAnchor constant:15]
                                                  ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.segmentControl.topAnchor constraintEqualToAnchor:self.topLayoutGuide.topAnchor constant:15]
                                                  ]];
    }
    
    [self.segmentControl setLeadingView:self.view constant:15];
    [self.segmentControl setTrailingView:self.view constant:15];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] init];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];

    //set constraints
    [self.tableView setBelowView:self.segmentControl constant:15];
    [self.tableView setBottomView:self.view];
    [self.tableView setSameLeadingTrailingView:self.view];
}

#pragma mark - FBRouteTimetableDelegate methods
- (void)routeTimetableDownloadFailedWithError:(NSError *)error {
    self.navigationItem.title = [NSString stringWithFormat:@"Error! [%@]", error.description];
}

- (void)routeTimetableDownloadedSuccessfully {
    [self.tableView reloadData];
    self.navigationItem.title = @"Data =";
}

#pragma mark - Segmented Control Interaction
- (void)didTapSegmentedControl:(UISegmentedControl *)segmentedControl {
    if(segmentedControl.selectedSegmentIndex == FBSegmentArrivals) {
        self.currentlyShowingData = self.timetableObj.arrivals;
        [self.tableView reloadData];
    }
    else {
        self.currentlyShowingData = self.timetableObj.departures;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentlyShowingData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"RouteStopCellIdentifier";
    
    FBRouteStopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[FBRouteStopTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    FBRouteStop *routeStop = [self.currentlyShowingData objectAtIndex:indexPath.row];
    [cell setRouteStop:routeStop];
    return cell;
}

@end
