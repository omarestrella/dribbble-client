//
//  StoreRequestSerializer.m
//  dribbble
//
//  Created by Omar Estrella on 12/30/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import "StoreRequestSerializer.h"

@implementation StoreRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(id)parameters error:(NSError *__autoreleasing *)error {
    NSMutableURLRequest *mutableRequest = [[super requestBySerializingRequest:request withParameters:parameters error:error] mutableCopy];
    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return mutableRequest;
}

@end
