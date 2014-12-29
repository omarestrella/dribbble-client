//
// Created by Omar Estrella on 11/15/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <Lockbox.h>

#import "APIAuthManager.h"

#import "Store.h"

@implementation APIAuthManager

- (AuthManager *)init {
    APIAuthManager *manager = (APIAuthManager *)[super init];

    if(manager) {
        manager.afManager = [AFHTTPRequestOperationManager manager];
        manager.store = [Store sharedStore];
    }

    return manager;
}

- (BOOL)isAuthenticated {
    return [Lockbox stringForKey:@"code"] != nil;
}

#pragma mark - OAuth authorization

- (PMKPromise *)authorizeWithCode:(NSString *)code {
    NSDictionary *data = @{
        @"client_id": clientId,
        @"client_secret": secret,
        @"code": code
    };

    return [self.afManager POST:@"https://dribbble.com/oauth/token" parameters:data]
        .then(^(NSDictionary *response) {
            [Lockbox setString:response[@"access_token"] forKey:@"code"];
            [self.store setAuthorizationHeader:response[@"access_token"]];
        }).then(^{
            // Eager loading...
            [self.store me];
        });
}

#pragma mark - Authentication URLs

- (NSString *)getRedirectUri {
    return redirectUri;
}

- (NSString *)getAuthorizeUrl {
    NSString *formatUrl = @"https://dribbble.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@";
    NSString *authorizeUrl = [NSString stringWithFormat:formatUrl, clientId, redirectUri, @"public comment"];
    return authorizeUrl;
}

- (NSString *)getTokenUrl {
    return @"https://dribbble.com/oauth/token";
}

@end