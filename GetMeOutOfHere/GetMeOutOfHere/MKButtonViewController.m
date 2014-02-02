//
//  MKButtonViewController.m
//  GetMeOutOfHere
//
//  Created by Richard Kim on 2/1/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import "MKButtonViewController.h"
#import "MKHelpButton.h"

@interface MKButtonViewController ()

@end

@implementation MKButtonViewController{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *locationName;
}
@synthesize helpButton;
@synthesize contactArray;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize myLongitude;
@synthesize myLatitude;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc]init];
    
    //%%% location stuff
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    geocoder = [[CLGeocoder alloc] init];
    
    
    //%%% btn stuff
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 2; //seconds
    longPress.delegate = self;
    [helpButton addGestureRecognizer:longPress];
    
    CALayer *btnLayer = [helpButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:2.0f];
    [helpButton setAlpha:0.9];
    //change button size and press down color
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Contact"
                                   inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.contactArray = [context executeFetchRequest:fetchRequest error:&error];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        myLongitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        myLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    // Reverse Geocoding
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            locationName = [NSString stringWithFormat:@"%@ %@, %@, %@",
                                 placemark.subThoroughfare, placemark.thoroughfare, placemark.locality,
                                 placemark.administrativeArea];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!"
                                                           message:@"There was a problem with this app \n try closing me and starting again"
                                                          delegate:nil
                                                 cancelButtonTitle:@"Sorry!"
                                                 otherButtonTitles:nil,nil];
            [alert show];
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        /*
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//+++++++++++++++++++++++++++++++++++++++++++++
//Helpful for us to delete all data in a model when called
//+++++++++++++++++++++++++++++++++++++++++++++
- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest * allEntities = [[NSFetchRequest alloc] init];
    [allEntities setEntity:[NSEntityDescription
                            entityForName:entityDescription
                            inManagedObjectContext:self.managedObjectContext]];
    [allEntities setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * events = [self.managedObjectContext executeFetchRequest:allEntities error:&error];
    //[allEntities release];
    //error handling goes here
    for (NSManagedObject * event in events) {
        [self.managedObjectContext deleteObject:event];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
    //more error handling here
}

- (IBAction)helpButtonAction:(id)sender {
    [helpButton setAlpha:0.9];
    [self stopAnimation];
}

-(void) handleLongPress : (id)sender
{
    [helpButton setAlpha:0.9];
    [self stopAnimation];
    MFMessageComposeViewController *textComposer = [[MFMessageComposeViewController alloc]init];
    [textComposer setMessageComposeDelegate:self];
    
    NSMutableArray *numbersTemp = [[NSMutableArray alloc] init];
    for(Contact *contact in contactArray)
    {
        [numbersTemp addObject:contact.phone];
    }
    
    NSArray *numbers = [numbersTemp copy];
    
    NSString *myLocation = @"I'm at ";
    myLocation = [myLocation stringByAppendingString:locationName];
    myLocation = [myLocation stringByAppendingString:@" ("];
    myLocation = [myLocation stringByAppendingString:myLatitude];
    myLocation = [myLocation stringByAppendingString:@", "];
    myLocation = [myLocation stringByAppendingString:myLongitude];
    myLocation = [myLocation stringByAppendingString:@"). Please get me out of here"];
    
    [textComposer setRecipients:numbers];
    [textComposer setBody:myLocation];
    [self presentViewController:textComposer animated:YES completion:NULL];
}

- (IBAction)buttonTouchDown:(id)sender {
    [self startAnimation];
    [helpButton setAlpha:0.6];
    //start animations
}

- (IBAction)buttonDragOutside:(id)sender {
    [helpButton setAlpha:0.9];
    [self stopAnimation];
    //cancel animation
}

-(void)startAnimation
{
    NSLog(@"start animation");
}

-(void)stopAnimation
{
    NSLog(@"stop animation");
}
@end
