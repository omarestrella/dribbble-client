//
//  RequestManager.m
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <Lockbox.h>

#import "AuthManager.h"

#import "AppConstants.h"

#import "APIAuthManager.h"
#import "MockAuthManager.h"

@implementation AuthManager

+ (AuthManager *)sharedManager {
    static AuthManager *sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
#ifdef MOCK
        NSLog(@"Mock auth manager generated...");
        sharedManager = [[MockAuthManager alloc] init];
#else
    NSLog(@"API auth manager generated...");
    sharedManager = [[APIAuthManager alloc] init];
#endif
    });
    return sharedManager;
}

- (BOOL)isAuthenticated {
    [NSError errorWithDomain:NSErrorDomain code:-1 userInfo:nil];
    return (BOOL) nil;

}

- (PMKPromise *)authorizeWithCode:(NSString *)code {
    [NSError errorWithDomain:NSErrorDomain code:-1 userInfo:nil];
    return nil;
}

- (NSString *)getAuthorizeUrl {
    [NSError errorWithDomain:NSErrorDomain code:-1 userInfo:nil];
    return nil;
}

@end
