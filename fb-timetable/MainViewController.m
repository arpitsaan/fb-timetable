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
#import "FBSectionHeaderView.h"
#import "FBRouteTableModel.h"
#import "UIColor+Hex.h" //FIXME - Add in Constant of PCH file.

typedef NS_ENUM( NSInteger, FBSegmentType ) {
    FBSegmentTypeArrivals = 0,
    FBSegmentTypeDepartures = 1
};

@interface MainViewController() <FBRouteTimetableDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) FBRouteTableModel *tableData;

@property(nonatomic, strong) UISegmentedControl *segmentControl;
@property(nonatomic, strong) FBRouteTimetable *timetableAPIObj;
@property(nonatomic, strong) NSArray *currentlyShowingData;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefaults];
    [self createViews];
    [self getData];
}

- (void)setupDefaults {
    self.currentlyShowingData = [[NSArray alloc] init];
    self.tableData = [[FBRouteTableModel alloc] init];
    [self.view setBackgroundColor:[UIColor colorWithHex:0xF7F7F4]];
    
    //navigation header
    self.navigationItem.title = @"Loading data...";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:0x73D700]];
}

- (void)getData {
    self.timetableAPIObj = [[FBRouteTimetable alloc] init];
    //FIXME - City Id
    [self.timetableAPIObj getFBRouteTimetableForCityId:@(1) delegate:self];
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
    [self.segmentControl setSelectedSegmentIndex:FBSegmentTypeArrivals];
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
    //FIXME - replace all color with hex with self
    [self.tableView setBackgroundColor:[UIColor colorWithHex:0xF7F7F4]];
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
    [self.tableData setRouteTimetable:self.timetableAPIObj];
    [self.tableView reloadData];
    self.navigationItem.title = @"Data =";
}

#pragma mark - Segmented Control Interaction
- (void)didTapSegmentedControl:(UISegmentedControl *)segmentedControl {
    if(segmentedControl.selectedSegmentIndex == FBSegmentTypeArrivals) {
        self.currentlyShowingData = self.timetableAPIObj.arrivals;
        [self.tableView reloadData];
    }
    else {
        self.currentlyShowingData = self.timetableAPIObj.departures;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.arrivalSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tableData.arrivalSections.count) {
        FBRouteSectionModel *currentSection = [self.tableData.arrivalSections objectAtIndex:section];
        return currentSection.sectionCells.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"RouteStopCellIdentifier";
    
    FBRouteStopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[FBRouteStopTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    FBRouteSectionModel *currentSection = [self.tableData.arrivalSections objectAtIndex:indexPath.row];
    FBRouteCellModel *cellVM = [currentSection.sectionCells objectAtIndex:indexPath.row];
    
    [cell setHighlighterText:cellVM.highlightText];
    [cell setTitleText:cellVM.titleText];
    [cell setSubtitleText:cellVM.subtitleText];
    [cell setAccessoryText:cellVM.accessoryText];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(self.tableData.arrivalSections.count) {
        FBSectionHeaderView *headerView = [[FBSectionHeaderView alloc] init];
        FBRouteSectionModel *sectionData = [self.tableData.arrivalSections objectAtIndex:section];
        
        //FIXME- SECTION TIME
        NSString *subtitle = [NSString stringWithFormat:@"%lu buses", (unsigned long)sectionData.sectionCells.count];
        FBRouteCellModel *cellData = sectionData.sectionCells.firstObject;
        [headerView setTitleText:cellData.accessoryText subtitleText:subtitle];
        
        return headerView;
    }
    
    return nil;
}

@end
