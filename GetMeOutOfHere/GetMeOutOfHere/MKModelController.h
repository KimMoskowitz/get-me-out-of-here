//
//  MKModelController.h
//  GetMeOutOfHere
//
//  Created by Jared Moskowitz on 2/1/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKDataViewController;

@interface MKModelController : NSObject <UIPageViewControllerDataSource>

- (MKDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(MKDataViewController *)viewController;

@end
