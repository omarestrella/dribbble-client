//
//  RequestManager.h
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit-AFNetworking/AFNetworking+PromiseKit.h>

#import "APIStore.h"

@interface AuthManager : NSObject

@property (nonatomic, strong) Store *store;

+ (AuthManager *)sharedManager;
- (AuthManager *)init;

- (BOOL)isAuthenticated;

- (PMKPromise *)authorizeWithCode:(NSString *)code;

- (NSString *)getAuthorizeUrl;

@end
