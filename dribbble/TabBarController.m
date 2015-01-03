//
//  TabBarController.m
//  dribbble
//
//  Created by Omar Estrella on 1/3/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "TabBarController.h"
#import "ShotsViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
//    NSMutableArray *vcs = [self.viewControllers mutableCopy];
//    [vcs addObject:[[ShotsViewController alloc] initWithCollectionViewLayout:[[UICollectionViewLayout alloc] init]]];
//    self.viewControllers = vcs;
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
