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

@implementation ShotCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];

    [self.imageView sd_cancelCurrentImageLoad];
    self.imageView.image = nil;
    self.imageView.image = [IonIcons imageWithIcon:icon_images
                                         iconColor:[UIColor lightGrayColor]
                                          iconSize:72.0f
                                         imageSize:self.frame.size];
}

@end
