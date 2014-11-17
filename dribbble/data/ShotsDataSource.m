//
//  ShotsDataSource.m
//  dribbble
//
//  Created by Omar Estrella on 11/9/14.
//  Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <IonIcons.h>

#import "ShotsDataSource.h"
#import "ShotCollectionViewCell.h"

@implementation ShotsDataSource

- (ShotsDataSource *)init {
    ShotsDataSource *source = (ShotsDataSource *)[super init];
    if (source) {
        source.store = (APIStore *)[APIStore sharedStore];
    }

    self.shots = @[];

    [source.store shots].then(^(NSArray *shots) {
        self.shots = shots;
//        [self reloadData];
    });
    
    return source;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShotCollectionViewCell *cell = (ShotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"shot" forIndexPath:indexPath];

    cell.imageView.image = [IonIcons imageWithIcon:icon_images
                                         iconColor:[UIColor lightGrayColor]
                                          iconSize:80.0f
                                         imageSize:cell.frame.size];
    
    NSUInteger index = (NSUInteger)indexPath.row;
    NSDictionary *shot = self.shots[index];
    NSLog(@"shot: %@", shot);
    NSString *path = shot[@"images"][@"normal"];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];

    UIImage *image = [UIImage imageWithData:data];

    CGFloat scaleX = cell.bounds.size.width / image.size.width;
    CGFloat scaleY = cell.bounds.size.height / image.size.height;
    CGFloat scale = MAX(scaleX, scaleY);
    cell.imageView.frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
    cell.imageView.image = image;

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.shots count];
}

@end
