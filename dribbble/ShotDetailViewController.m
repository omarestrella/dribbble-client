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
    [self handleImage];

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

- (void)handleImage {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *shotUrl = self.shot.images[@"hidpi"];
    if (!shotUrl || shotUrl == (id) [NSNull null]) {
        shotUrl = self.shot.images[@"normal"];
    }
    
    __block CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 0.75f);
    CGSize loadingSize = {frame.size.width, frame.size.height};
    UIImage *loadingImage = [self.collectionImage imageToFitSize:loadingSize
                                                          method:MGImageResizeScale];
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = frame;
    self.shotImage.image = loadingImage;
    [self.shotImage addSubview:effectView];
    
    NSURL *url = [NSURL URLWithString:shotUrl];
    
    CGRect loadingFrame = CGRectMake(self.view.frame.size.width / 2 - 40.f, self.view.frame.size.width / 4,
                                     80.f, 80.f);
    MRCircularProgressView *progressView = [[MRCircularProgressView alloc] initWithFrame:loadingFrame];
    progressView.valueLabel.textColor = [UIColor whiteColor];
    progressView.tintColor = [UIColor whiteColor];
    [self.shotImage addSubview:progressView];
    
    [manager downloadImageWithURL:url options:SDWebImageContinueInBackground
                         progress:(SDWebImageDownloaderProgressBlock) ^(NSInteger receivedSize, NSInteger expectedSize) {
                             float progress = receivedSize / (float)expectedSize;
                             [progressView setProgress:progress animated:YES];
                         }
                        completed:(SDWebImageCompletionWithFinishedBlock) ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                            if (image) {
                                CGFloat scale = self.view.bounds.size.width / image.size.width;
                                frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
                                CGSize size = {image.size.width * scale, image.size.height * scale};
                                self.shotImage.frame = frame;
                                UIImage *resizedImage = [image imageToFitSize:size method:MGImageResizeScale];
                                
                                [MRProgressOverlayView dismissOverlayForView:self.shotImage animated:YES];
                                [UIView animateWithDuration:0.4f
                                                 animations:^{
                                                     effectView.alpha = 0.0f;
                                                     progressView.alpha = 0.0f;
                                                 }
                                                 completion:^(BOOL complete) {
                                                     [effectView removeFromSuperview];
                                                     [progressView removeFromSuperview];
                                                 }];
                                
                                self.shotImage.image = resizedImage;
                                
                                NSLog(@"%@", [resizedImage CIImage].properties);
                                
                                if([self.shot isGIF]) {
                                    NSLog(@"got gif");
                                    CGRect frame = self.view.frame;
                                    CGRect rect = CGRectMake(frame.size.width - 40, 140, 30, 16);
                                    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ShotGifLabelView" owner:self options:nil] firstObject];
                                    view.frame = rect;
                                    [self.view addSubview:view];
                                } else { NSLog(@"%@", self.shot.images); }
                            }
                        }];
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