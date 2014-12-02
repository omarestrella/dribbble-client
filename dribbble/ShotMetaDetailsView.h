//
// Created by Omar Estrella on 11/29/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShotMetaDetailsView : UIView

@property (nonatomic, weak) IBOutlet UILabel *views;

@property (nonatomic, weak) IBOutlet UILabel *likes;

- (void)setupData:(NSDictionary *)shot;

@end