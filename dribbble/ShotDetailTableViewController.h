//
// Created by Omar Estrella on 11/18/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShotDetailTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) NSDictionary *shot;

@end