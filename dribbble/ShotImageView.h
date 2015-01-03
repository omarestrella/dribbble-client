//
//  ShotImageView.h
//  dribbble
//
//  Created by Omar Estrella on 1/2/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLAnimatedImageView.h>

#import "ShotModel.h"

@interface ShotImageView : UIImageView<UIWebViewDelegate>

@property (weak, nonatomic) ShotModel *shot;
@property (weak, nonatomic) FLAnimatedImageView *imageView;
//@property (weak, nonatomic) UIWebView *webView;

@end
