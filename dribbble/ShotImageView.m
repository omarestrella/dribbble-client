//
//  ShotImageView.m
//  dribbble
//
//  Created by Omar Estrella on 1/2/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <FLAnimatedImage.h>
#import <MRProgress.h>

#import "ShotImageView.h"

@implementation ShotImageView {
    BOOL showingImage;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];
    
    return self;
}

- (void)tap {
    if ([self.shot isGIF]) {
        NSLog(@"touched");
        
        if (showingImage) {
            [self.imageView removeFromSuperview];
            showingImage = NO;
        } else {
            CGRect loadingFrame = CGRectMake(self.frame.size.width / 2 - 40.f, self.frame.size.width / 4,
                                             80.f, 80.f);
            MRActivityIndicatorView *loading = [[MRActivityIndicatorView alloc] initWithFrame:loadingFrame];
            loading.tintColor = [UIColor colorWithWhite:1.000 alpha:0.7];
            [loading startAnimating];
            [self addSubview:loading];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithFrame:self.frame];
                FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[self.shot URL]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.animatedImage = image;
                    [self addSubview:imageView];
                    self.imageView = imageView;
                });
                
                [loading stopAnimating];
                [loading removeFromSuperview];
            });
            
            showingImage = YES;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
