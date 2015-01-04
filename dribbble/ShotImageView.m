//
//  ShotImageView.m
//  dribbble
//
//  Created by Omar Estrella on 1/2/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <FLAnimatedImage.h>
#import <MRProgress.h>
#import <SDWebImageManager.h>

#import "ShotImageView.h"
#import "UIImage+ProportionalFill.h"

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

- (void)loadWithFrame:(CGRect)frame loadingImage:(UIImage *)loadingImage {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    CGSize loadingSize = {frame.size.width, frame.size.height};
    loadingImage = [loadingImage imageToFitSize:loadingSize
                                                          method:MGImageResizeScale];
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = frame;
    self.image = loadingImage;
    [self addSubview:effectView];
    
    NSURL *url = [self.shot URL];
    
    CGRect loadingFrame = CGRectMake(self.frame.size.width / 2 - 30.f, self.frame.size.width / 4,
                                     80.f, 80.f);
    MRCircularProgressView *progressView = [[MRCircularProgressView alloc] initWithFrame:loadingFrame];
    progressView.valueLabel.textColor = [UIColor whiteColor];
    progressView.tintColor = [UIColor whiteColor];
    [self addSubview:progressView];
    
    [manager downloadImageWithURL:url options:SDWebImageContinueInBackground
                         progress:(SDWebImageDownloaderProgressBlock) ^(NSInteger receivedSize, NSInteger expectedSize) {
                             float progress = receivedSize / (float)expectedSize;
                             [progressView setProgress:progress animated:YES];
                         }
                        completed:(SDWebImageCompletionWithFinishedBlock) ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                            if (image) {
                                CGFloat scale = self.bounds.size.width / image.size.width;
                                CGRect newFrame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
                                CGSize size = {image.size.width * scale, image.size.height * scale};
                                self.frame = newFrame;
                                UIImage *resizedImage = [image imageToFitSize:size method:MGImageResizeScale];
                                
                                [UIView animateWithDuration:0.4f
                                                 animations:^{
                                                     effectView.alpha = 0.0f;
                                                     progressView.alpha = 0.0f;
                                                 }
                                                 completion:^(BOOL complete) {
                                                     [effectView removeFromSuperview];
                                                     [progressView removeFromSuperview];
                                                 }];
                                
                                self.image = resizedImage;
                            }
                        }];
}

- (void)tap {
    if ([self.shot isGIF]) {
        if (showingImage) {
            [self.imageView removeFromSuperview];
            showingImage = NO;
        } else {
            CGRect loadingFrame = CGRectMake(self.frame.size.width / 2 - 30.f, self.frame.size.width / 4,
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
