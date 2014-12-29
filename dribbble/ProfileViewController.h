//
//  ProfileViewController.h
//  dribbble
//
//  Created by Omar Estrella on 12/29/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserModel.h"

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) UserModel *user;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView *shotsContainer;

@end
