//
//  CommentTextField.m
//  dribbble
//
//  Created by Omar Estrella on 12/25/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import "CommentTextField.h"

@implementation CommentTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 8, 0);
//    return CGRectMake(bounds.origin.x + 8, bounds.origin.y, bounds.size.width, bounds.size.height);
    
//    return [super textRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
