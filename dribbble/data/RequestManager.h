//
//  RequestManager.h
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit-AFNetworking/AFNetworking+PromiseKit.h>

@interface RequestManager : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

+ (RequestManager *)sharedManager;

- (BOOL)isAuthenticated;
- (void)setAuthorizationHeader:(NSString *)code;

- (PMKPromise *)userForId:(NSInteger *)userId;

- (PMKPromise *)authorizeWithCode:(NSString *)code;

- (NSString *)getAuthorizeUrl;

@end
