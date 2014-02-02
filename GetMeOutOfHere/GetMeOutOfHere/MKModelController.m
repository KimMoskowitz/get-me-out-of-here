//
//  MKModelController.m
//  GetMeOutOfHere
//
//  Created by KimMoskowitz on 2/1/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import "MKModelController.h"
#import "MKButtonViewController.h"
#import "MKContactViewController.h"
#import "MKDataViewController.h"
#import "MKMessageViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface MKModelController()
@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation MKModelController
@synthesize dataViewController;

- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
        MKButtonViewController *buttonVC = [[MKButtonViewController alloc]init];
        MKContactViewController *contactVC = [[MKContactViewController alloc]init];
        MKMessageViewController *messageVC = [[MKMessageViewController alloc]init];
        
        _pageData = @[messageVC,buttonVC,contactVC];
    }
    return self;
}

- (MKDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"MKDataViewController"];
//    dataViewController.dataObject = self.pageData[index];
    
    NSLog(@"INDEX: %u", index);
    
    if (index == 0) {
        dataViewController = [[MKMessageViewController alloc]init];
    }
    else if (index == 1) {
        dataViewController = [[MKButtonViewController alloc]init];
    }
    else if (index == 2) {
        dataViewController = [[MKContactViewController alloc]init];
    }
    else {
        return nil;
    }
    
    dataViewController.pageIndex = index;
    
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(MKDataViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = (dataViewController.pageIndex);
    NSLog(@"BEFORE INDEX: %u", index);
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"AFTER INDEX: %u", index);
    NSUInteger index = (dataViewController.pageIndex);
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
