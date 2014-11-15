//
//  ShotsViewController.m
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <AFHTTPRequestOperation.h>
#import <Lockbox.h>
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
    
    [Lockbox initialize];
    
    self.store = [Store sharedStore];
    self.dataSource = [[ShotsDataSource alloc] init];
    
    [self setupProfileButton];
    
    self.collectionView.dataSource = self.dataSource;
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAuthAttempt:)
                                                 name:@"authAttempt"
                                               object:nil];
    
    NSString *code = [Lockbox stringForKey:@"code"];
    if (code != nil) {
        [self authenticateWithCode:code];
    } else {
        AuthViewController *vc = [[AuthViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - Authentication

- (void)handleAuthAttempt:(NSNotification *)notification {
    NSDictionary *data = [notification userInfo];
    if (data[@"code"]) {
        [self authenticateWithCode:data[@"code"]];
    }
}

- (void)authenticateWithCode:(NSString *)code {
    AuthManager *manager = [AuthManager sharedManager];
    
    if(!self.authenticated) {
        [manager authorizeWithCode:code]
            .then(^(NSDictionary *response) {               
                if (self.presentedViewController) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }

                self.authenticated = true;
                
                [self.store me];
                
                return [self.store shots];
            })
            .then(^(NSArray *shots) {
                [self.collectionView reloadData];
            })
            .catch(^(NSError *error) {
                NSURL *url = error.userInfo[@"NSErrorFailingURLKey"];
               
                if ([url.absoluteString hasSuffix:@"token"]) {
                    [Lockbox setString:@"" forKey:@"code"];
                    
                    AuthViewController *vc = [[AuthViewController alloc] init];
                    [self presentViewController:vc animated:YES completion:nil];
                }
            });
    }
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
