//
// Created by Omar Estrella on 11/18/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <SDWebImageManager.h>
#import <PromiseKit/Promise.h>
#import <MRProgress/MRProgress.h>

#import "ShotDetailViewController.h"
#import "UIImage+ProportionalFill.h"
#import "ShotCommentCell.h"

@implementation ShotDetailViewController

- (void)viewDidLoad {
    self.shotHeader.title.text = self.shot.title;
    self.shotHeader.author.text = [NSString stringWithFormat:@"by %@", self.shot.user[@"username"]];

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *shotUrl = self.shot.images[@"hidpi"];
    if (!shotUrl || shotUrl == (id) [NSNull null]) {
        shotUrl = self.shot.images[@"normal"];
    }

    __block CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 0.75f);
    CGSize loadingSize = {frame.size.width, frame.size.height};
    UIImage *loadingImage = [self.collectionImage imageToFitSize:loadingSize
                                                          method:MGImageResizeScale];
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = frame;
    self.shotImage.image = loadingImage;
    [self.shotImage addSubview:effectView];

    NSURL *url = [NSURL URLWithString:shotUrl];

    CGRect loadingFrame = CGRectMake(self.view.frame.size.width / 2 - 40.f, self.view.frame.size.width / 4,
        80.f, 80.f);
    MRCircularProgressView *progressView = [[MRCircularProgressView alloc] initWithFrame:loadingFrame];
    progressView.valueLabel.textColor = [UIColor whiteColor];
    progressView.tintColor = [UIColor whiteColor];
    [self.shotImage addSubview:progressView];

    [manager downloadImageWithURL:url options:SDWebImageContinueInBackground
                         progress:(SDWebImageDownloaderProgressBlock) ^(NSInteger receivedSize, NSInteger expectedSize) {
                             float progress = receivedSize / (float)expectedSize;
                             [progressView setProgress:progress animated:YES];
                         }
                        completed:(SDWebImageCompletionWithFinishedBlock) ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                            if (image) {
                                CGFloat scale = self.view.bounds.size.width / image.size.width;
                                frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
                                CGSize size = {image.size.width * scale, image.size.height * scale};
                                self.shotImage.frame = frame;
                                UIImage *resizedImage = [image imageToFitSize:size method:MGImageResizeScale];

                                [MRProgressOverlayView dismissOverlayForView:self.shotImage animated:YES];
                                [UIView animateWithDuration:0.4f
                                                 animations:^{
                                                     effectView.alpha = 0.0f;
                                                     progressView.alpha = 0.0f;
                                                 }
                                                 completion:^(BOOL complete) {
                                                     [effectView removeFromSuperview];
                                                     [progressView removeFromSuperview];
                                                 }];

                                self.shotImage.image = resizedImage;
                            }
                        }];

    [self.shot comments].then(^(NSArray *comments) {
        self.comments = comments;

        [self.commentsTableView reloadData];

        [self adjustCommentsHeight];
    });

    self.commentsTableView.dataSource = self;
    self.commentsTableView.delegate = self;

    [self.shotMeta setupData:self.shot];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)adjustCommentsHeight {
    CGFloat animHeight = self.commentsTableView.contentSize.height + 500;

    [UIView animateWithDuration:0.25 animations:^{
        self.commentsHeightConstraint.constant = animHeight;
        [self.view layoutIfNeeded];
    } completion:^(BOOL completed) {
        self.commentsHeightConstraint.constant = self.commentsTableView.contentSize.height;
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShotCommentCell *cell = (ShotCommentCell *) [tableView dequeueReusableCellWithIdentifier:@"commentCell"];

    if (!cell) {
        cell = [[ShotCommentCell alloc] init];
    }

    if (self.comments && indexPath.row < self.comments.count) {
        NSRange range;
        NSDictionary *comment = self.comments[indexPath.row];
        NSString *body = comment[@"body"];

        body = [body stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
        while ((range = [body rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
            body = [body stringByReplacingCharactersInRange:range withString:@""];
        }

        cell.comment.text = body;
    }

    if (indexPath.row % 2 == 0) {
        UIColor *color = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.2];
        cell.backgroundColor = color;
        cell.comment.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.comments) {
        return self.comments.count;
    }

    return 0;
}

#pragma mark - UITableViewDelegate

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    ShotHeaderView *headerCell = (ShotHeaderView *) [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
//    headerCell.title.text = self.shot.title;
//    headerCell.author.text = [NSString stringWithFormat:@"by %@", self.shot.user[@"username"]];
//    headerCell.layoutMargins = UIEdgeInsetsMake(0, 20, 0, 0);
//    return headerCell;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Comments";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *) view;
    header.textLabel.font = [UIFont boldSystemFontOfSize:12];
//    header.layoutMargins = UIEdgeInsetsMake(0, 20, 0, 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

@end