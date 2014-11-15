//
//  ShotsViewController.h
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "APIStore.h"
#import "ShotsDataSource.h"

@interface ShotsViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) BOOL authenticated;
@property (nonatomic, strong) Store *store;
@property (nonatomic, strong) ShotsDataSource *dataSource;

@end
