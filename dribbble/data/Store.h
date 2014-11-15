//
//  Store.h
//  dribbble
//
//  Created by Omar Estrella on 11/15/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit-AFNetworking/AFNetworking+PromiseKit.h>

@interface Store : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) NSMutableDictionary *cache;

+ (Store *)sharedStore;
- (Store *)init;

- (void)setAuthorizationHeader:(NSString *)code;

- (PMKPromise *)me;
- (PMKPromise *)userForId:(NSNumber *)userId;
- (PMKPromise *)shots;

@end
