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
#import "UIColor+Hex.h"

typedef NS_ENUM( NSInteger, FBSegmentType ) {
    FBSegmentTypeArrivals = 0,
    FBSegmentTypeDepartures = 1
};

@interface MainViewController() <FBRouteTimetableDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) FBRouteTableModel *tableData;
@property(nonatomic, strong) FBRouteTimetable *timetableAPIObj;
@property(nonatomic, strong) NSArray *currentlyShowingData;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UISegmentedControl *segmentControl;
@property(nonatomic, strong) UIActivityIndicatorView *loader;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefaults];
    [self setupNavigationBar];
    [self createViews];
    [self getData];
}

- (void)setupDefaults {
    self.currentlyShowingData = [[NSArray alloc] init];
    self.tableData = [[FBRouteTableModel alloc] init];
    
    [self.view setBackgroundColor:[UIColor colorWithHex:0xF7F7F4]];
    
}

- (void)getData {
    self.navigationItem.title = @"Fetching timings...";
    [self.loader startAnimating];
    self.timetableAPIObj = [[FBRouteTimetable alloc] init];
    [self.timetableAPIObj getFBRouteTimetableForCityId:@(1) delegate:self];
}

#pragma mark - View Setup
- (void)setupNavigationBar {
    //navigation header
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:0x73D700]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightBold]}];
}

- (void)createViews {
    [self createLoader];
    [self createSegmentedControl];
    [self createTableView];
}

- (void)createLoader {
    self.loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.navigationController.navigationBar addSubview:self.loader];
    [self.loader setHidesWhenStopped:YES];
    
    [self.loader setBottomView:self.navigationController.navigationBar constant:12.0f];
    [self.loader setTrailingView:self.navigationController.navigationBar constant:12.0f];
}

- (void)createSegmentedControl {
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Arrivals", @"Departures", nil]];
    
    //customize appearance
    UIFont *font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.segmentControl setTitleTextAttributes:attributes                                    forState:UIControlStateNormal];
    [self.segmentControl setBackgroundColor:UIColor.whiteColor];
    [self.segmentControl setSelectedSegmentIndex:FBSegmentTypeArrivals];
    [self.segmentControl addTarget:self action:@selector(didToggleSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentControl];
    [self.segmentControl setTintColor:[UIColor colorWithHex:0x73D700]];
    [self.segmentControl setHidden:YES];
    
    //setup constraints
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
    [self.tableView setBackgroundColor:[UIColor colorWithHex:0xF7F7F4]];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setAllowsSelection:NO];
    [self.view addSubview:self.tableView];

    //set constraints
    [self.tableView setBelowView:self.segmentControl constant:15];
    [self.tableView setBottomView:self.view];
    [self.tableView setSameLeadingTrailingView:self.view];
}

#pragma mark - FBRouteTimetableAPIDelegate methods
- (void)routeTimetableDownloadFailedWithError:(NSError *)error {
    [self.tableView reloadData];
    [self.segmentControl setHidden:YES];
    self.navigationItem.title = @"Berlin ZOB";
}

- (void)routeTimetableDownloadedSuccessfully {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        
        //create View Model in background thread
        [self.tableData setRouteTimetable:self.timetableAPIObj];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Main Thread
            [self.tableView reloadData];
            [self.segmentControl setHidden:NO];
            self.navigationItem.title = @"Berlin ZOB";
            [self.loader stopAnimating];
        });
    });
}

#pragma mark - Segmented Control Interaction
- (void)didToggleSegmentedControl:(UISegmentedControl *)segmentedControl {
    if(segmentedControl.selectedSegmentIndex == FBSegmentTypeArrivals) {
        self.currentlyShowingData = self.timetableAPIObj.arrivals;
    }
    else {
        self.currentlyShowingData = self.timetableAPIObj.departures;
    }
    
    [self.tableView setContentOffset:CGPointZero];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource Methods
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
    
    FBRouteSectionModel *currentSection = [self.tableData.arrivalSections objectAtIndex:indexPath.section];
    FBRouteCellModel *cellVM = [currentSection.sectionCells objectAtIndex:indexPath.row];
    
    [cell setHighlighterText:cellVM.highlightText];
    [cell setTitleText:cellVM.titleText];
    [cell setSubtitleText:cellVM.subtitleText];
    [cell setAccessoryText:cellVM.accessoryText];
    [cell setIconImage:[UIImage imageNamed:@"clock-icon"]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(self.tableData.arrivalSections.count) {
        //create header
        FBSectionHeaderView *headerView = [[FBSectionHeaderView alloc] init];
        FBRouteSectionModel *sectionData = [self.tableData.arrivalSections objectAtIndex:section];
        
        //set data
        NSString *subtitle = [NSString stringWithFormat:@"%lu buses", (unsigned long)sectionData.sectionCells.count];
        [headerView setTitleText:sectionData.sectionTitle subtitleText:subtitle];
        
        return headerView;
    }
    
    return nil;
}

@end