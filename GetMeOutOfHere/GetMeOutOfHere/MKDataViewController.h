//
//  MKDataViewController.h
//  GetMeOutOfHere
//
//  Created by KimMoskowitz on 2/1/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKDataViewController : UIViewController

//@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;
@property (nonatomic) NSUInteger pageIndex;

@end
