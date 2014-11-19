//
// Created by Omar Estrella on 11/15/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import "MockStore.h"


@implementation MockStore

- (Store *)init {
    return [super init];
}

- (void)setAuthorizationHeader:(NSString *)code {

}

- (PMKPromise *)me {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSDictionary *user = [self mockDataForFile:@"user"];
        fulfill(user);
    }];
}

- (PMKPromise *)shots:(int)page {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:30];
        NSDictionary *shot = [self mockDataForFile:@"shot"];
        for (int i = 0; i < 30; ++i) {
            [array addObject:shot];
        }
        fulfill(array);
    }];
}

- (NSDictionary *)mockDataForFile:(NSString *)file {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

@end