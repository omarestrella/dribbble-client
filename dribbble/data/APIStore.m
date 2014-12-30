//
//  APIStore.m
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <Mantle.h>

#import "APIStore.h"
#import "ShotModel.h"

@implementation APIStore {
    @private
    UserModel *currentUser;
}

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

- (PMKPromise *)me {
    if (currentUser) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(currentUser);
        }];
    }
    
    return [self userForId:nil];
}

- (PMKPromise *)userForId:(NSNumber *)userId {
    NSString *url;
    NSDictionary *cacheUser;
    
    if (userId) {
        url = [NSString stringWithFormat:@"users/%ld", (long) userId];
    } else {
        url = [NSString stringWithFormat:@"user"];
    }

    if (userId) {
        cacheUser = self.cache[@"user"][userId];
    }

    if (cacheUser) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(cacheUser);
        }];
    }

    return [self.manager GET:url parameters:nil].then(^(NSDictionary *userData) {
        UserModel *user = [MTLJSONAdapter modelOfClass:UserModel.class fromJSONDictionary:userData error:nil];
        [self storeUser:user];
        return user;
    });
}

- (PMKPromise *)shots:(int)page {
    NSString *url = @"shots";

    NSMutableDictionary *params = [@{
        @"per_page" : @30
    } mutableCopy];

    if (page) {
        params[@"page"] = @(page);
    }

    return [self.manager GET:url parameters:params].then(^(NSArray *shots) {
        NSMutableArray *shotModels = [NSMutableArray arrayWithCapacity:shots.count];
        for (NSDictionary *shot in shots) {
            ShotModel *model = [MTLJSONAdapter modelOfClass:ShotModel.class fromJSONDictionary:shot error:nil];
            if(![shotModels containsObject:model]) {
                [shotModels addObject:model];
            }
        }

        self.cache[@"shots"] = shots;

        return shotModels;
    });
}

- (PMKPromise *)commentsForShot:(ShotModel *)shot {
    NSNumber *comments = shot.comments_count;
    NSDictionary *params = @{
                             @"per_page": comments
                             };
    return [self.manager GET:shot.comments_url parameters:params].then(^(NSArray *comments) {
        self.cache[@"comments"] = comments;

        return comments;
    });
}

- (PMKPromise *)likesComment:(NSDictionary *)comment forShot:(ShotModel *)shot {
    NSNumber *commentId = comment[@"id"];
    NSString *url = [NSString stringWithFormat:@"shots/%@/comments/%@/like", shot.id, commentId];
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [self.manager GET:url parameters:nil].then(^{
            fulfill(@YES);
        }).catch(^{
            fulfill(@NO);
        });
    }];
}

#pragma mark - Cache

- (void)setupCache {
    self.cache = [@{
        @"users" : @{},
        @"shots" : @[]
    } mutableCopy];
}

- (void)storeUser:(UserModel *)user {
    NSNumber *userId = user.id;
    self.cache[@"user"][userId] = user;
}

@end
