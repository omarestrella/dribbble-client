//
//  ShotsViewController.m
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <AFHTTPRequestOperation.h>
#import <IonIcons.h>

#import "ShotsViewController.h"
#import "AuthViewController.h"
#import "ShotCollectionViewCell.h"

#import "AuthManager.h"

@interface ShotsViewController ()

@end

@implementation ShotsViewController {
    BOOL _authenticated;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.store = [Store sharedStore];
    self.dataSource = [[ShotsDataSource alloc] init];
    
    [self setupProfileButton];
    
    self.collectionView.dataSource = self.dataSource;
}

- (void)viewDidAppear:(BOOL)animated {
//    NSString *code = [Lockbox stringForKey:@"code"];
//    if (code != nil) {
//        [self authenticateWithCode:code];
//    } else {
//        AuthViewController *vc = [[AuthViewController alloc] init];
//        [self presentViewController:vc animated:YES completion:nil];
//    }
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

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.contentSize.width;
    CGFloat size = width / 4;
    return CGSizeMake(size, size);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
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
