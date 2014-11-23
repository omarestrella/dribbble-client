//
// Created by Omar Estrella on 11/18/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <SDWebImageManager.h>

#import "ShotDetailTableViewController.h"
#import "ShotHeaderTableViewCell.h"
#import "ShotImageTableViewCell.h"

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

    if (indexPath.section == 0 && indexPath.row == 0) {
        ShotImageTableViewCell *imageCell = (ShotImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"imageCell"
                                                                                                      forIndexPath:indexPath];
        NSURL *url = [NSURL URLWithString:self.shot[@"images"][@"normal"]];
        [manager downloadImageWithURL:url options:nil progress:nil
                            completed:(SDWebImageCompletionWithFinishedBlock) ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                if (image) {
                                    CGFloat scale = imageCell.bounds.size.width / image.size.width;
                                    CGRect frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
                                    imageCell.imageView.frame = frame;
                                    imageCell.imageView.image = image;
                                }
                            }];
        cell = imageCell;
    }

    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }

    return cell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }

    return 12;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ShotHeaderTableViewCell *headerCell = (ShotHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    headerCell.title.text = self.shot[@"title"];
    headerCell.author.text = [NSString stringWithFormat:@"by %@", self.shot[@"user"][@"username"]];
    return headerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSInteger width = [self.shot[@"width"] integerValue];
        NSInteger height = [self.shot[@"height"] integerValue];
        CGFloat scale = tableView.contentSize.width / width;
        return height * scale;
    }

    return 60;
}

@end