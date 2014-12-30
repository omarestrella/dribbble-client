//
// Created by Omar Estrella on 11/29/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShotModel.h"

@interface ShotMetaDetailsView : UIView

@property (nonatomic, weak) IBOutlet UILabel *views;

@property (nonatomic, weak) IBOutlet UILabel *likes;

@property (nonatomic, weak) IBOutlet UILabel *buckets;

- (void)setupData:(ShotModel *)shot;

@end