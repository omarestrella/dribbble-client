//
//  RequestManager.h
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperation.h>

@interface RequestManager : NSObject

+ (RequestManager *)sharedManager;

- (NSString *)getAuthorizeUrl;

- (void)authorizeWithCode:(NSString *)code success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
