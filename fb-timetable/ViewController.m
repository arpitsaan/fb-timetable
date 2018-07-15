//
//  ViewController.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createViews {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
