//
//  Store.m
//  dribbble
//
//  Created by Omar Estrella on 11/15/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import "Store.h"

#import "AppConstants.h"

#import "APIStore.h"
#import "MockStore.h"

@implementation Store

+ (Store *)sharedStore {
    static Store *sharedStore = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
#ifdef MOCK
        NSLog(@"Mock store generated...");
        sharedStore = [[MockStore alloc] init];
#else
        NSLog(@"API store generated");
        sharedStore = [[APIStore alloc] init];
#endif
    });
    return sharedStore;
}

- (void)setAuthorizationHeader:(NSString *)code {
    [NSError errorWithDomain:NSErrorDomain code:-1 userInfo:nil];
}

- (PMKPromise *)me {
    [NSError errorWithDomain:NSErrorDomain code:-1 userInfo:nil];
    return nil;
}

- (PMKPromise *)userForId:(NSNumber *)userId {
    [NSError errorWithDomain:NSErrorDomain code:-1 userInfo:nil];
    return nil;
}

- (PMKPromise *)shots:(int)page {
    [NSError errorWithDomain:NSErrorDomain code:-1 userInfo:nil];
    return nil;
}

- (PMKPromise *)commentsForShot:(ShotModel *)shot {
    [NSError errorWithDomain:NSErrorDomain code:-1 userInfo:nil];
    return nil;
}

- (PMKPromise *)likesComment:(NSDictionary *)comment forShot:(ShotModel *)shot {
    [NSError errorWithDomain:NSErrorDomain code:-1 userInfo:nil];
    return nil;
}

@end
