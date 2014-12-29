//
//  ProfileTableViewController.h
//  dribbble
//
//  Created by Omar Estrella on 12/28/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserModel.h"

@interface ProfileTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UserModel *user;

@end
