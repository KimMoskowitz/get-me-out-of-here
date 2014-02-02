//
//  MKButtonViewController.h
//  GetMeOutOfHere
//
//  Created by Richard Kim on 2/1/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDataViewController.h"
#import "MessageUI/MessageUI.h"
#import "Contact.h"

@interface MKButtonViewController :MKDataViewController <MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
- (IBAction)helpButtonAction:(id)sender;

@property (strong, nonatomic) NSArray *contactArray;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



@end
