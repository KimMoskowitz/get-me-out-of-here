//
//  MKMessageTable.h
//  GetMeOutOfHere
//
//  Created by Richard Kim on 2/2/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKMessageViewController.h"
@class MKMessageViewController;

@interface MKMessageTable : UITableView
@property (strong, nonatomic) MKMessageViewController *messageVC;

@end
