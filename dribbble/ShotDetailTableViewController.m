//
// Created by Omar Estrella on 11/18/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <SDWebImageManager.h>

#import "ShotDetailTableViewController.h"
#import "ShotHeaderTableViewCell.h"

@implementation ShotDetailTableViewController

- (void)viewDidLoad {
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    UITableViewCell *cell;

    if (indexPath.row == 0) {
        ShotHeaderTableViewCell *headerCell = (ShotHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"headerCell"
                                                                                                         forIndexPath:indexPath];
        headerCell.title.text = self.shot[@"title"];
        cell = headerCell;
    }

    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

@end