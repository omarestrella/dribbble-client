//
//  ShotsViewController.m
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <AFHTTPRequestOperation.h>
#import <Lockbox.h>

#import "ShotsViewController.h"
#import "AuthViewController.h"

#import "RequestManager.h"

@interface ShotsViewController ()

@end

@implementation ShotsViewController {
    BOOL _authenticated;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Lockbox initialize];
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

#pragma mark - Authentication

- (void)handleAuthAttempt:(NSNotification *)notification {
    NSDictionary *data = [notification userInfo];
    if (data[@"code"]) {
        [self authenticateWithCode:data[@"code"]];
    }
}

- (void)authenticateWithCode:(NSString *)code {
    RequestManager *manager = [RequestManager sharedManager];
    
    if(!self.authenticated) {
        [manager authorizeWithCode:code]
            .then(^(NSDictionary *response) {
                NSLog(@"Successful authentication");
               
                if (self.presentedViewController) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
               
                self.authenticated = true;
               
                [Lockbox setString:response[@"access_token"] forKey:@"code"];
                [manager setAuthorizationHeader:response[@"access_token"]];
                
                return [manager userForId:nil];
            })
            .then(^(NSDictionary *response) {
                NSLog(@"Loading up some data: %@", response);
            })
            .catch(^(NSError *error) {
                NSLog(@"Error handling auth: %@", error);
                
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
