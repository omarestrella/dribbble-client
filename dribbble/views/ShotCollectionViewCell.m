//
//  ShotCollectionViewCell.m
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <IonIcons.h>

#import "ShotCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ProportionalFill.h"

@implementation ShotCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    if (self.currentOperation) {
        [self.currentOperation cancel];
    }
    
    self.imageView.image = nil;
}

- (void)handleShot:(ShotModel *)shot {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    NSString *path = shot.images[@"teaser"];
    NSURL *url = [NSURL URLWithString:path];
    
    self.currentOperation = [manager
                             downloadImageWithURL:url
                             options:SDWebImageContinueInBackground
                             progress:nil
                             completed:(SDWebImageCompletionWithFinishedBlock) ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                 if (image) {
                                     if ([path isEqualToString:shot.images[@"teaser"]]) {
                                         self.imageView.layer.opacity = 0.0;
                                         
                                         CGFloat scaleX = self.bounds.size.width / image.size.width;
                                         CGFloat scaleY = self.bounds.size.height / image.size.height;
                                         CGFloat scale = MIN(scaleX, scaleY);
                                         CGSize size = {image.size.width * scale, image.size.height * scale};
                                         
                                         self.imageView.frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
                                         
                                         UIImage *resizedImage = [image imageToFitSize:size method:MGImageResizeScale];
                                         
                                         self.imageView.image = resizedImage;
                                         
                                         [UIView animateWithDuration:0.5 animations:^{
                                             self.imageView.layer.opacity = 1.0;
                                         }];
                                     } else {
                                         NSLog(@"no match");
                                     }
                                 }
                             }];
}

@end
