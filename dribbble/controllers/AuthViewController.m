//
//  AuthViewController.m
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <Lockbox.h>

#import "AuthViewController.h"
#import "AuthManager.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [Lockbox initialize];

#ifdef MOCK
    [self authenticateWithCode:@"code"];
#else
    AuthManager *manager = [AuthManager sharedManager];

    NSString *urlString = [manager getAuthorizeUrl];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    UIWebView *view = [[UIWebView alloc] initWithFrame:[self.view frame]];

    view.userInteractionEnabled = YES;
    view.delegate = self;
    [view loadRequest:request];

    [self.view addSubview:view];
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAuthAttempt:)
                                                 name:@"authAttempt"
                                               object:nil];
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
    AuthManager *manager = [AuthManager sharedManager];

    [manager authorizeWithCode:code]
        .then(^(NSDictionary *response) {
            [self performSegueWithIdentifier:@"successfulAuth" sender:self];
        })
        .catch(^(NSError *error) {
            NSURL *url = error.userInfo[@"NSErrorFailingURLKey"];

            if ([url.absoluteString hasSuffix:@"token"]) {
                [Lockbox setString:@"" forKey:@"code"];

                [self performSegueWithIdentifier:@"login" sender:self];
            }
        });
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finished loading");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error loading: %@", error);
    
    if (error.code == -1009 || error.code == -1005) {
        NSLog(@"No internet connection");
        
        NSString *msg = @"We could not reach Dribbble. Please check your network connection and try again.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:msg
                                                       delegate:self cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self performSegueWithIdentifier:@"login" sender:self];
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
