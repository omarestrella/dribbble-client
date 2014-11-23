//
// Created by Omar Estrella on 11/18/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShotHeaderView.h"

@interface ShotDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) NSDictionary *shot;

@property (weak, nonatomic) IBOutlet ShotHeaderView *shotHeader;
@property (weak, nonatomic) IBOutlet UIImageView *shotImage;

@end