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
@property(nonatomic, strong) NSArray *selectedSectionsArray;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UISegmentedControl *segmentControl;
@property(nonatomic, strong) UIActivityIndicatorView *loader;

@end

@implementation MainViewController

#pragma mark - Init Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefaults];
    [self setupNavigationBar];
    [self createViews];
    [self getData];
}

- (void)setupDefaults {
    self.selectedSectionsArray = [[NSArray alloc] init];
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
    
    //customize segment control appearance
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
    [self.tableView setAllowsSelection:NO];
    [self.view addSubview:self.tableView];

    //set constraints
    [self.tableView setBelowView:self.segmentControl constant:2.0f];
    [self.tableView setBottomView:self.view];
    [self.tableView setSameLeadingTrailingView:self.view];
}

#pragma mark - FBRouteTimetableAPIDelegate methods
- (void)routeTimetableDownloadFailedWithError:(NSError *)error {
    [self.tableView reloadData];
    [self.segmentControl setHidden:YES];
    [self.loader stopAnimating];
    
    //show alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed to fetch timings" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    self.navigationItem.title = @"Failed to fetch data - Retry";
    
    //retry button
    UIBarButtonItem *retryButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(didTapRetryButton)];
    [retryButton setTintColor:UIColor.whiteColor];
    self.navigationItem.rightBarButtonItems = @[retryButton];
}

- (void)didTapRetryButton {
    self.navigationItem.rightBarButtonItems = nil;
    [self getData];
}

- (void)routeTimetableDownloadedSuccessfully {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        
        //process and create view model in background thread
        [self.tableData setRouteTimetable:self.timetableAPIObj];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //reload all data on main Thread
            [self refreshViewWithData];
        });
    });
}

- (void)refreshViewWithData {
    self.selectedSectionsArray = self.tableData.arrivalSections;
    
    //update header
    self.navigationItem.title = self.tableData.headerTitle;
    [self.loader stopAnimating];
    
    //update view
    [self.segmentControl setHidden:NO];
    [self.tableView reloadData];
    
    //clean up api object
    [self.timetableAPIObj cleanUpData];
}


#pragma mark - Segmented Control Interaction
- (void)didToggleSegmentedControl:(UISegmentedControl *)segmentedControl {
    if(segmentedControl.selectedSegmentIndex == FBSegmentTypeArrivals) {
        self.selectedSectionsArray = self.tableData.arrivalSections;
    }
    else {
        self.selectedSectionsArray = self.tableData.departureSections;
    }
    
    [self.tableView setContentOffset:CGPointZero];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.selectedSectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedSectionsArray.count) {
        FBRouteSectionModel *currentSection = [self.selectedSectionsArray objectAtIndex:section];
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
    
    FBRouteSectionModel *currentSection = [self.selectedSectionsArray objectAtIndex:indexPath.section];
    FBRouteCellModel *cellVM = [currentSection.sectionCells objectAtIndex:indexPath.row];
    
    //input cell data with view model
    [cell setHighlighterText:cellVM.highlightText];
    [cell setTitleText:cellVM.titleText];
    [cell setSubtitleText:cellVM.subtitleText];
    [cell setAccessoryText:cellVM.accessoryText];
    [cell setIconImage:[UIImage imageNamed:@"clock-icon"]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(self.selectedSectionsArray.count) {
        //create header
        FBSectionHeaderView *headerView = [[FBSectionHeaderView alloc] init];
        FBRouteSectionModel *sectionData = [self.selectedSectionsArray objectAtIndex:section];
        
        //set data
        NSString *subtitle = [NSString stringWithFormat:@"%lu buses", (unsigned long)sectionData.sectionCells.count];
        [headerView setTitleText:sectionData.sectionTitle subtitleText:subtitle];
        
        return headerView;
    }
    
    return nil;
}

@end
