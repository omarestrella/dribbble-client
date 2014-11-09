//
//  RequestManager.m
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <Lockbox.h>

#import "RequestManager.h"

NSString static *baseUrl = @"https://api.dribbble.com/v1";
NSString static *clientId = @"6767af960a29bbc938b08548e2ee7bc8e97845471bc6eb07dfc87c8ab06eb16f";
NSString static *secret = @"6d1d8e47e363c2945e271ca6cb111b8726ed33503d9998ceb2862de5c104f286";
NSString static *redirectUri = @"dribbble://auth";

@implementation RequestManager

+ (RequestManager *)sharedManager {
    static RequestManager *sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[RequestManager alloc] init];
    });
    return sharedManager;
}

- (RequestManager *)init {
    RequestManager *manager = [super init];

    manager.requestManager = [AFHTTPRequestOperationManager manager];
    manager.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    return manager;
}

- (BOOL)isAuthenticated {
    return [Lockbox stringForKey:@"code"] != nil;
}

- (void)setAuthorizationHeader:(NSString *)code {
    NSString *header = [NSString stringWithFormat:@"Bearer %@", code];
    [self.requestManager.requestSerializer setValue:header forHTTPHeaderField:@"Authorization"];
}

#pragma mark - API Interface

- (PMKPromise *)userForId:(NSInteger *)userId {
    NSString *url;
    if (userId) {
        url = [NSString stringWithFormat:@"%@/users/%ld", baseUrl, (long)userId];
    } else {
        url = [NSString stringWithFormat:@"%@/user", baseUrl];
    }
    return [self.requestManager GET:url parameters:nil];
}

#pragma mark - OAuth authorization

- (void)performInitialAuthorizationWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *url = [[self getAuthorizeUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.requestManager GET:url parameters:nil
         success:success
         failure:success];
}

- (PMKPromise *)authorizeWithCode:(NSString *)code {
    NSDictionary *data = @{
                           @"client_id": clientId,
                           @"client_secret": secret,
                           @"code": code
                           };
    
    return [self.requestManager POST:@"https://dribbble.com/oauth/token" parameters:data];
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
