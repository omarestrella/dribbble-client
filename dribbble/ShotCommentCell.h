//
// Created by Omar Estrella on 12/7/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShotCommentCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end