//
//  ShotModel.h
//  dribbble
//
//  Created by Omar Estrella on 11/13/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "UserModel.h"

@class PMKPromise;

@interface ShotModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *id;

@property (nonatomic, copy, readonly) UserModel *user;
@property (nonatomic, copy, readonly) NSDictionary *team;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy, readonly) NSString *shotDescription;

@property (nonatomic, copy, readonly) NSNumber *width;
@property (nonatomic, copy, readonly) NSNumber *height;

@property (nonatomic, copy, readonly) NSDictionary *images;

@property (nonatomic, copy) NSNumber *views_count;
@property (nonatomic, copy) NSNumber *likes_count;
@property (nonatomic, copy) NSNumber *comments_count;
@property (nonatomic, copy) NSNumber *attachments_count;
@property (nonatomic, copy) NSNumber *rebounds_count;
@property (nonatomic, copy) NSNumber *buckets_count;

@property (nonatomic, copy, readonly) NSDate *created_at;
@property (nonatomic, copy) NSDate *updated_at;

@property (nonatomic, copy) NSString *html_url;
@property (nonatomic, copy) NSString *attachments_url;
@property (nonatomic, copy) NSString *buckets_url;
@property (nonatomic, copy) NSString *comments_url;
@property (nonatomic, copy) NSString *likes_url;
@property (nonatomic, copy) NSString *projects_url;
@property (nonatomic, copy) NSString *rebounds_url;

@property (nonatomic, copy, readonly) NSArray *tags;

- (BOOL)isGIF;

- (PMKPromise *)comments;
- (PMKPromise *)likes:(NSDictionary *)comment;

- (PMKPromise *)like:(NSDictionary *)comment;
- (PMKPromise *)unlike:(NSDictionary *)comment;

@end
