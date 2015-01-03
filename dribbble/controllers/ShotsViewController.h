//
//  ShotsViewController.h
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "APIStore.h"

typedef NS_ENUM(NSUInteger, ShotCategory) {
    Popular,
    Following
};

@interface ShotsViewController : UICollectionViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property BOOL loading;
@property int currentPage;
@property ShotCategory type;

@property (nonatomic, strong) Store *store;

@property (nonatomic, strong) NSMutableArray *shots;

@end
