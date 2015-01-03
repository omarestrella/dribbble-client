//
//  ShotModel.m
//  dribbble
//
//  Created by Omar Estrella on 11/13/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <PromiseKit-AFNetworking/AFNetworking+PromiseKit.h>

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

- (BOOL)isGIF {
    NSString *normal = self.images[@"normal"];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"^[\\S]+.gif$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *result = [regex firstMatchInString:normal options:0 range:NSMakeRange(0, normal.length)];
    return result != nil;
}

- (NSURL *)URL {
    NSString *shotUrl = self.images[@"hidpi"];
    if (!shotUrl || shotUrl == (id) [NSNull null]) {
        shotUrl = self.images[@"normal"];
    }
    return [NSURL URLWithString:shotUrl];
}

- (PMKPromise *)comments {
    return [[Store sharedStore] commentsForShot:self];
}

- (PMKPromise *)likes:(NSDictionary *)comment {
    return [[Store sharedStore] likesComment:comment forShot:self];
}

- (PMKPromise *)like:(NSDictionary *)comment {
    return [[Store sharedStore] like:comment forShot:self];
}

- (PMKPromise *)unlike:(NSDictionary *)comment {
    return [[Store sharedStore] unlike:comment forShot:self];
}

@end
