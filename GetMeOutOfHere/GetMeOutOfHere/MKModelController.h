//
//  MKModelController.h
//  GetMeOutOfHere
//
//  Created by KimMoskowitz on 2/1/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDataViewController.h"

@class MKDataViewController;

@interface MKModelController : NSObject <UIPageViewControllerDataSource>

- (MKDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(MKDataViewController *)viewController;
@property (strong, nonatomic) MKDataViewController *dataViewController;

@end
