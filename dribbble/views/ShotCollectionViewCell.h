//
//  ShotCollectionViewCell.h
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLAnimatedImageView.h>

#import "SDWebImageDownloaderOperation.h"
#import "ShotModel.h"

@interface ShotCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet FLAnimatedImageView *imageView;

@property (nonatomic, weak) SDWebImageDownloaderOperation *currentOperation;

- (void)handleShot:(ShotModel *)shot;

@end
