//
// Created by Omar Estrella on 11/18/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <SDWebImageManager.h>

#import "ShotDetailViewController.h"
#import "UIImage+ProportionalFill.h"

@implementation ShotDetailViewController

- (void)viewDidLoad {
    self.shotHeader.title.text = self.shot[@"title"];
    self.shotHeader.author.text = [NSString stringWithFormat:@"by %@", self.shot[@"user"][@"username"]];

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *shotUrl = self.shot[@"images"][@"hidpi"];
    if (!shotUrl || shotUrl == (id)[NSNull null]) {
        shotUrl = self.shot[@"images"][@"normal"];
    }
    NSURL *url = [NSURL URLWithString:shotUrl];
    [manager downloadImageWithURL:url options:SDWebImageContinueInBackground progress:nil
                        completed:(SDWebImageCompletionWithFinishedBlock) ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                            if (image) {
                                CGFloat scale = self.view.bounds.size.width / image.size.width;
                                CGRect frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
                                CGSize size = {image.size.width * scale, image.size.height * scale};
                                self.shotImage.frame = frame;
                                UIImage *resizedImage = [image imageToFitSize:size method:MGImageResizeScale];
                                self.shotImage.image = resizedImage;
                            }
                        }];

    self.commentsTableView.dataSource = self;
    self.commentsTableView.delegate = self;

    [self.shotMeta setupData:self.shot];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self adjustCommentsHeight];
}

- (void)adjustCommentsHeight {
    CGFloat height = self.commentsTableView.contentSize.height + 30;

    [UIView animateWithDuration:0.25 animations:^{
        self.commentsHeightConstraint.constant = height;
        [self.view needsUpdateConstraints];
    }];

}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];

    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ShotHeaderView *headerCell = (ShotHeaderView *)[tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    headerCell.title.text = self.shot[@"title"];
    headerCell.author.text = [NSString stringWithFormat:@"by %@", self.shot[@"user"][@"username"]];
    return headerCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Comments";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont boldSystemFontOfSize:12];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 60;
}

@end