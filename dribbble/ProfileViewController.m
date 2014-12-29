//
//  ProfileViewController.m
//  dribbble
//
//  Created by Omar Estrella on 12/29/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <SDWebImageManager.h>

#import "ProfileViewController.h"
#import "UIImage+ProportionalFill.h"
#import "Store.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[Store sharedStore] me].then(^(UserModel *user) {
        self.user = user;
        
        self.name.text = user.name;
        
        [self setupImage];
    });
}

- (void)setupImage {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    NSURL *url = [NSURL URLWithString:self.user.avatar_url];
    
    NSInteger sizeValue = 96;
    
    [manager downloadImageWithURL:url options:SDWebImageContinueInBackground
                         progress:(SDWebImageDownloaderProgressBlock) ^(NSInteger receivedSize, NSInteger expectedSize) {}
                        completed:(SDWebImageCompletionWithFinishedBlock) ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                            if (image) {
                                CGSize size = {sizeValue, sizeValue};
                                UIImage *resizedImage = [image imageToFitSize:size method:MGImageResizeScale];
                                
                                self.imageView.image = resizedImage;
                                
                                CALayer *layer = self.imageView.layer;
                                [layer setMasksToBounds:YES];
                                [layer setCornerRadius:sizeValue / 2];
                                
                                [UIView animateWithDuration:0.5 animations:^{
                                    self.imageView.layer.opacity = 1.0;
                                }];
                            }
                        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
