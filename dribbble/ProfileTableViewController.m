//
//  ProfileTableViewController.m
//  dribbble
//
//  Created by Omar Estrella on 12/28/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ProfileMainTableViewCell.h"

#import "Store.h"

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[Store sharedStore] me].then(^(UserModel *user) {
        self.user = user;
        
        [self.tableView reloadData];
    });
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.user) {
        return 2;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.user) {
        if (section == 0) {
            return 1;
        } else if (section == 1) {
            return 2;
        } else {
            return 0;
        }
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    if (self.user) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            ProfileMainTableViewCell *cell = (ProfileMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"mainUserCell"
                                                                                                         forIndexPath:indexPath];
            [cell setupUser:self.user];
            return cell;
        } else {
            return [tableView dequeueReusableCellWithIdentifier:@"userDataCell" forIndexPath:indexPath];;
        }
    } else {
        return [tableView dequeueReusableCellWithIdentifier:@"userDataCell" forIndexPath:indexPath];;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Your Profile";
    }
    
    return @"";
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
