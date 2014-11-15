//
// Created by Omar Estrella on 11/15/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <Lockbox.h>

#import "MockAuthManager.h"


@implementation MockAuthManager

- (AuthManager *)init {
    return [super init];
}

- (PMKPromise *)authorizeWithCode:(NSString *)code {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [Lockbox setString:@"code" forKey:@"code"];
        fulfill(@{});
    }];
}

@end