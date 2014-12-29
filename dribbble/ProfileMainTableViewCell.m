//
//  ProfileMainTableViewCell.m
//  dribbble
//
//  Created by Omar Estrella on 12/29/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <SDWebImageManager.h>

#import "ProfileMainTableViewCell.h"
#import "UIImage+ProportionalFill.h"

@implementation ProfileMainTableViewCell

- (void)setupUser:(UserModel *)user {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    self.nameLabel.text = user.name;
    
    NSURL *url = [NSURL URLWithString:user.avatar_url];
    
    [manager downloadImageWithURL:url options:SDWebImageContinueInBackground
                         progress:(SDWebImageDownloaderProgressBlock) ^(NSInteger receivedSize, NSInteger expectedSize) {}
                        completed:(SDWebImageCompletionWithFinishedBlock) ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                            if (image) {
                                CGSize size = {48, 48};
                                CGRect frame = CGRectMake(self.frame.size.width / 2 - 24, 8, 48, 48);
                                UIImage *resizedImage = [image imageToFitSize:size method:MGImageResizeScale];

                                self.imageView.frame = frame;
                                self.imageView.image = resizedImage;
                            }
                        }];
}

@end