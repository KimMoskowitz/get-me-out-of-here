//
//  MKContactViewController.h
//  GetMeOutOfHere
//
//  Created by Jared Moskowitz on 2/1/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import "MKDataViewController.h"
#import "MKContact.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Contact.h"

@interface MKContactViewController : MKDataViewController <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *contactsArray;

// The contacts object will allow us to access the device contacts.
@property (nonatomic, retain) ABPeoplePickerNavigationController *contacts;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (IBAction)addContact:(id)sender;


@end
