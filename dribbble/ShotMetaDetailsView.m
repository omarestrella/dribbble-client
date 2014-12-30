//
// Created by Omar Estrella on 11/29/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import "ShotMetaDetailsView.h"


@implementation ShotMetaDetailsView

- (NSString *)abbreviateNumber:(NSNumber *)number {
    double num = (double)[number integerValue];
    NSArray *suffix = @[@"k", @"m", @"b"];

    if (num >= 1000) {
        for (int i = (int)suffix.count - 1; i >= 0; i--) {
            double size = pow(10, (i + 1) * 3);
            if (size <= num) {
                num = num / size;
                NSString *numString = [self floatToString:num];
                return [NSString stringWithFormat:@"%@%@", numString, suffix[i]];
            }
        }

        return [NSString stringWithFormat:@"%@", number];
    } else {
        return [NSString stringWithFormat:@"%@", number];
    }
}

- (NSString *) floatToString:(double)val {
    NSString *ret = [NSString stringWithFormat:@"%.1f", val];
    unichar c = [ret characterAtIndex:[ret length] - 1];

    while (c == 48) { // 0
        ret = [ret substringToIndex:[ret length] - 1];
        c = [ret characterAtIndex:[ret length] - 1];

        //After finding the "." we know that everything left is the decimal number, so get a substring excluding the "."
        if(c == 46) { // .
            ret = [ret substringToIndex:[ret length] - 1];
        }
    }

    return ret;
}

- (void)setupData:(ShotModel *)shot {
    NSNumber *viewCount = shot.views_count;
    NSString *views = [NSString stringWithFormat:@"%@ views", [self abbreviateNumber:viewCount]];
    self.views.text = views;

    NSNumber *likeCount = shot.likes_count;
    NSString *likes = [NSString stringWithFormat:@"%@ likes", [self abbreviateNumber:likeCount]];
    self.likes.text = likes;
    
    NSNumber *bucketsCout = shot.buckets_count;
    NSString *buckets = [NSString stringWithFormat:@"%@ buckets", [self abbreviateNumber:bucketsCout]];
    self.buckets.text = buckets;
}

@end