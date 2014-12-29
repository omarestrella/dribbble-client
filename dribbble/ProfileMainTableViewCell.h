//
//  ProfileMainTableViewCell.h
//  dribbble
//
//  Created by Omar Estrella on 12/29/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserModel.h"

@interface ProfileMainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)setupUser:(UserModel *)user;

@end
