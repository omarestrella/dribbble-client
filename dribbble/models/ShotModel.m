//
//  ShotModel.m
//  dribbble
//
//  Created by Omar Estrella on 11/13/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import "ShotModel.h"
#import "Store.h"

@implementation ShotModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"shotDescription" : @"description",
    };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:UserModel.class];
}

- (PMKPromise *)comments {
    return [[Store sharedStore] commentsForShot:self];
}

- (PMKPromise *)likes:(NSDictionary *)comment {
    return [[Store sharedStore] likesComment:comment forShot:self];
}

- (PMKPromise *)like:(NSDictionary *)comment {
    return nil;
}

- (PMKPromise *)unlike:(NSDictionary *)comment {
    return nil;
}

@end
