//
//  APIStore.m
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import "APIStore.h"

@implementation APIStore

- (APIStore *)init {
    APIStore *store = (APIStore *) [super init];

    if (store) {
        NSURL *url = [NSURL URLWithString:@"https://api.dribbble.com/v1/"];
        store.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
        store.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        store.manager.requestSerializer = [AFJSONRequestSerializer serializer];

        [store setupCache];
    }

    return store;
}

- (void)setAuthorizationHeader:(NSString *)code {
    NSString *header = [NSString stringWithFormat:@"Bearer %@", code];
    [self.manager.requestSerializer setValue:header forHTTPHeaderField:@"Authorization"];
}

#pragma mark - API calls

- (PMKPromise *)userForId:(NSNumber *)userId {
    NSString *url;
    if (userId) {
        url = [NSString stringWithFormat:@"users/%ld", (long) userId];
    } else {
        url = [NSString stringWithFormat:@"user"];
    }

    NSDictionary *cacheUser = self.cache[@"user"][userId];

    if (cacheUser) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(cacheUser);
        }];
    }

    return [self.manager GET:url parameters:nil].then(^(NSDictionary *user) {
        [self storeUser:user];
        return user;
    });
}

- (PMKPromise *)shots:(int)page {
    NSString *url = @"shots";

    NSMutableDictionary *params = [@{
        @"per_page" : @40
    } mutableCopy];

    if (page) {
        params[@"page"] = @(page);
    }

    return [self.manager GET:url parameters:params].then(^(NSArray *shots) {
        self.cache[@"shots"] = shots;
        return shots;
    });
}

#pragma mark - Cache

- (void)setupCache {
    self.cache = [@{
        @"users" : @{},
        @"shots" : @[]
    } mutableCopy];
}

- (void)storeUser:(NSDictionary *)user {
    NSNumber *userId = user[@"id"];
    self.cache[@"user"][userId] = user;
}

@end
