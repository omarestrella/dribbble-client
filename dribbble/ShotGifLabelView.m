//
//  ShotGifLabelView.m
//  dribbble
//
//  Created by Omar Estrella on 1/2/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "ShotGifLabelView.h"

@implementation ShotGifLabelView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    self.layer.cornerRadius = 2.0;
    self.layer.masksToBounds = YES;
    
    return self;
}

@end
