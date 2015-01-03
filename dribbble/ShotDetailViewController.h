//
// Created by Omar Estrella on 11/18/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShotHeaderView.h"
#import "ShotMetaDetailsView.h"
#import "ShotModel.h"
#import "ShotImageView.h"

@interface ShotDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) NSArray *comments;
@property (nonatomic, weak) ShotModel *shot;

@property (nonatomic, assign) CGFloat lastContentOffset;

@property (nonatomic, weak) UIImage *collectionImage;

@property (weak, nonatomic) IBOutlet ShotHeaderView *shotHeader;
@property (weak, nonatomic) IBOutlet ShotImageView *shotImage;
@property (weak, nonatomic) IBOutlet ShotMetaDetailsView *shotMeta;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *commentSubmitButton;

@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsHeightConstraint;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)webButtonPress:(id)sender;

- (IBAction)touchedMoreButton:(UIButton *)sender;

@end