//
// Created by Omar Estrella on 11/15/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import "MockStore.h"


@implementation MockStore

- (void)setAuthorizationHeader:(NSString *)code {

}

- (PMKPromise *)me {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

    }];
}

- (PMKPromise *)shots {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

    }];
}

@end