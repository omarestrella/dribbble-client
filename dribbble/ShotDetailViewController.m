//
// Created by Omar Estrella on 11/18/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <SDWebImageManager.h>
#import <PromiseKit/Promise.h>
#import <MRProgress/MRProgress.h>

#import "ShotDetailViewController.h"
#import "UIImage+ProportionalFill.h"
#import "ShotCommentCell.h"
#import "Store.h"
#import "ShotGifLabelView.h"

@implementation ShotDetailViewController {
    BOOL keyboardShown;
}

- (void)viewDidLoad {
    keyboardShown = NO;
    
    self.lastContentOffset = 0;
    
    self.shotHeader.title.text = self.shot.title;
    self.shotHeader.author.text = [NSString stringWithFormat:@"by %@", self.shot.user.name];

    [self setupGestures];
    [self setupImage];

    [self.shot comments].then(^(NSArray *comments) {
        self.comments = comments;

        [self.commentsTableView reloadData];

        [self adjustCommentsHeight];
    });

    self.commentsTableView.dataSource = self;
    self.commentsTableView.delegate = self;
    
    self.scrollView.delegate = self;
    self.commentTextField.delegate = self;
    
    self.scrollView.canCancelContentTouches = NO;

    [self.shotMeta setupData:self.shot];
}

#pragma mark - Core View

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForKeyboardNotifications];
    
    [[Store sharedStore] me].then(^(UserModel *user) {
        if(![user canComment]) {
            [self.commentTextField removeFromSuperview];
            [self.commentSubmitButton removeFromSuperview];
        }
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
}

#pragma mark - Custom

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)deregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary *data = [notification userInfo];
    CGSize viewSize = self.view.frame.size;
    CGSize keyboardSize = [data[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                                     viewSize.width, viewSize.height - keyboardSize.height);
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + keyboardSize.height - 16)];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    NSDictionary *data = [notification userInfo];
    CGSize keyboardSize = [data[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize viewSize = self.view.frame.size;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                                     viewSize.width, viewSize.height + keyboardSize.height);
    }];
}

- (void)handleSingleTap {
    [self.commentTextField resignFirstResponder];
}

- (void)setupGestures {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [singleTap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:singleTap];
}

- (void)setupImage {
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 0.75f);
    
    self.shotImage.shot = self.shot;
    [self.shotImage loadWithFrame:frame loadingImage:self.collectionImage];

    if([self.shot isGIF]) {
        CGRect frame = self.scrollView.frame;
        CGRect rect = CGRectMake(frame.size.width - 40, 10, 30, 16);
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ShotGifLabelView" owner:self options:nil] firstObject];
        view.frame = rect;
        [self.scrollView addSubview:view];
    }
}

- (void)adjustCommentsHeight {
    CGFloat animHeight = self.commentsTableView.contentSize.height + 500;

    [UIView animateWithDuration:0.25 animations:^{
        self.commentsHeightConstraint.constant = animHeight;
        [self.view layoutIfNeeded];
    } completion:^(BOOL completed) {
        self.commentsHeightConstraint.constant = self.commentsTableView.contentSize.height;
    }];
}

- (IBAction)webButtonPress:(id)sender {
    NSURL *url = [NSURL URLWithString:self.shot.html_url];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"Failed open shot URL: %@", [url description]);
    }
}

- (IBAction)touchedMoreButton:(UIButton *)sender {
    ShotCommentCell *cell = (ShotCommentCell *)sender.superview.superview;
    NSIndexPath *index = [self.commentsTableView indexPathForCell:cell];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSDictionary *comment = self.comments[index.row];
    [self.shot likes:comment].then(^(NSNumber *likesComment) {
        NSString *like = [likesComment isEqualToNumber:@YES] ? @"Unlike" : @"Like";
        [alert addAction:[UIAlertAction actionWithTitle:like style:UIAlertActionStyleDefault handler:^(UIAlertAction *handler) {
            if ([likesComment isEqualToNumber:@YES]) {
                [self.shot unlike:comment];
            } else {
                [self.shot like:comment];
            }
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShotCommentCell *cell = (ShotCommentCell *) [tableView dequeueReusableCellWithIdentifier:@"commentCell"];

    if (!cell) {
        cell = [[ShotCommentCell alloc] init];
    }

    if (self.comments && indexPath.row < self.comments.count) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];

        NSDictionary *comment = self.comments[indexPath.row];
        NSString *body = comment[@"body"];
        NSString *name = comment[@"user"][@"name"];
        NSRange range;
        
        body = [body stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
        while ((range = [body rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
            body = [body stringByReplacingCharactersInRange:range withString:@""];
        }

        cell.comment.text = body;
        cell.name.text = [name uppercaseString];
        
        NSString *profileUrl = comment[@"user"][@"avatar_url"];
        NSURL *url = [NSURL URLWithString:profileUrl];

        [manager downloadImageWithURL:url options:SDWebImageContinueInBackground
                             progress:(SDWebImageDownloaderProgressBlock) ^(NSInteger receivedSize, NSInteger expectedSize) {}
                            completed:(SDWebImageCompletionWithFinishedBlock) ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                if (image) {
                                    CGRect frame = CGRectMake(0, 0, 32, 32);
                                    CGSize size = {32, 32};
                                    cell.profileImage.frame = frame;
                                    UIImage *resizedImage = [image imageToFitSize:size method:MGImageResizeScale];
                                    
                                    cell.profileImage.image = resizedImage;
                                }
                            }];

    } else {
        cell.comment.text = @" ";
        cell.name.text = @" ";
        cell.profileImage.frame = CGRectMake(0, 0, 32, 32);
    }

    if (indexPath.row % 2 == 0) {
        UIColor *color = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.2];
        cell.backgroundColor = color;
        cell.comment.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.comments) {
        return self.comments.count;
    }

    return 2;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Comments";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *) view;
    header.textLabel.font = [UIFont boldSystemFontOfSize:12];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

@end