//
//  APIStore.h
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit-AFNetworking/AFNetworking+PromiseKit.h>

#import "Store.h"

@interface APIStore : Store

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

//+ (APIStore *)sharedStore;

- (void)setAuthorizationHeader:(NSString *)code;

//- (PMKPromise *)userForId:(NSNumber *)userId;
//- (PMKPromise *)shots;

@end
