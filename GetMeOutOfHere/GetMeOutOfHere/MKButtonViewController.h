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
#import <CoreLocation/CoreLocation.h>

@interface MKButtonViewController :MKDataViewController <MFMessageComposeViewControllerDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;


@property (strong, nonatomic) NSArray *contactArray;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSString *myLatitude;
@property (strong, nonatomic) NSString *myLongitude;


//%%% button stuff
- (IBAction)buttonTouchDown:(id)sender;
- (IBAction)buttonDragOutside:(id)sender;
- (IBAction)helpButtonAction:(id)sender;

-(void)startAnimation;
-(void)stopAnimation;
@end
