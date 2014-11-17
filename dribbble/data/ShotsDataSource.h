//
//  ShotsDataSource.h
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "APIStore.h"

@interface ShotsDataSource : NSObject<UICollectionViewDataSource>

@property (nonatomic, strong) APIStore *store;

@property(nonatomic, strong) NSArray *shots;

@end
