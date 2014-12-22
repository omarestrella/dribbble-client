//
//  UserModel.h
//  dribbble
//
//  Created by Omar Estrella on 12/22/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface UserModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *id;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *username;

@property (nonatomic, copy, readonly) NSString *html_url;
@property (nonatomic, copy, readonly) NSString *avatar_url;

@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSMutableDictionary *links;

@property (nonatomic, copy, readonly) NSNumber *buckets_count;
@property (nonatomic, copy, readonly) NSNumber *followers_count;
@property (nonatomic, copy, readonly) NSNumber *following_count;
@property (nonatomic, copy, readonly) NSNumber *likes_count;
@property (nonatomic, copy, readonly) NSNumber *projects_count;
@property (nonatomic, copy, readonly) NSNumber *shots_count;
@property (nonatomic, copy, readonly) NSNumber *teams_count;

@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, readonly) BOOL pro;

@property (nonatomic, copy, readonly) NSString *buckets_url;
@property (nonatomic, copy, readonly) NSString *followers_url;
@property (nonatomic, copy, readonly) NSString *following_url;
@property (nonatomic, copy, readonly) NSString *likes_url;
@property (nonatomic, copy, readonly) NSString *shots_url;
@property (nonatomic, copy, readonly) NSString *teams_url;

@property (nonatomic, copy, readonly) NSString *created_at;
@property (nonatomic, copy, readonly) NSString *updated_at;

@end
