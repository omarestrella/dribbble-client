//
//  AuthViewController.m
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import "AuthViewController.h"
#import "RequestManager.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RequestManager *manager = [RequestManager sharedManager];
    NSString *urlString = [manager getAuthorizeUrl];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding : NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIWebView *view = [[UIWebView alloc] initWithFrame:[self.view frame]];
    view.delegate = self;
    [view loadRequest:request];
    
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - WKNavigationDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finished loading");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error loading: %@", error);
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
