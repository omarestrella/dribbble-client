//
//  ShotsViewController.m
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <AFHTTPRequestOperation.h>
#import <IonIcons.h>
#import <SDWebImageManager.h>

#import "ShotsViewController.h"
#import "ShotCollectionViewCell.h"
#import "ShotDetailViewController.h"
#import "UIImage+ProportionalFill.h"
#import "ShotModel.h"

@interface ShotsViewController () {
    BOOL _loading;
    int _currentPage;
}

@end

@implementation ShotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.dataSource = self;

    self.store = [Store sharedStore];
    self.shots = [@[] mutableCopy];

    self.currentPage = 1;

    [self.store shots:self.currentPage].then(^(NSArray *shots) {
        [self.shots addObjectsFromArray:shots];
        [self.collectionView reloadData];
    });

    [self setupProfileButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupProfileButton {
    UIImage *icon = [IonIcons imageWithIcon:icon_ios7_person
                                  iconColor:[UIColor whiteColor]
                                   iconSize:32.0f
                                  imageSize:CGSizeMake(20.0f, 90.0f)];

    [self.navigationItem.rightBarButtonItem setImage:icon];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offset = scrollView.contentOffset.y;

    if (height + offset >= contentHeight - 150) {
        if (!self.loading) {
            self.loading = YES;
            [self.store shots:self.currentPage += 1].then(^(NSArray *shots) {
                [self.shots addObjectsFromArray:shots];
                [self.collectionView reloadData];
                self.loading = NO;
            });
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShotCollectionViewCell *cell = (ShotCollectionViewCell *)[collectionView
                                                              dequeueReusableCellWithReuseIdentifier:@"shot"
                                                              forIndexPath:indexPath];
    NSUInteger index = (NSUInteger) indexPath.row;
    ShotModel *shot = self.shots[index];

    [cell handleShot:shot];

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.shots count];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.contentSize.width;
    CGFloat size = width / 2;
    return CGSizeMake(size, size / (4.0f/3.0f));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"shotDetail"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
        ShotModel *shot = (self.shots)[(NSUInteger) indexPath.row];
        ShotDetailViewController *vc = (ShotDetailViewController *)[segue destinationViewController];
        vc.collectionImage = ((ShotCollectionViewCell *)sender).imageView.image;
        vc.shot = shot;
    }
}

@end
