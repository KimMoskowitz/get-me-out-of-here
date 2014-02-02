//
//  MKContactViewController.m
//  GetMeOutOfHere
//
//  Created by Jared Moskowitz on 2/1/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import "MKContactViewController.h"
#import "MKCell.h"
#import "sendgrid.h"
#import "AFNetworking.h"

@interface MKContactViewController ()

@end



@implementation MKContactViewController

@synthesize table;
@synthesize contactsArray;
@synthesize contacts;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }//contactsArray[0].fullName or .phone
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

   
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Contact"
                                   inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    contactsArray = [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:&error]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Delegate Methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [contactsArray count];//[contactsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Make sure to change the default style to the next one if you want to manage to display text
        // in the detailsTextLabel area.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell.
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if(contactsArray.count == 0)
    {
        cell.textLabel.text = @"";
        return cell;
    }
    
    // Specify the current row.
    NSInteger currentRow = [indexPath row];

    // Display the selected contact's info.
    // First the full name, then the phone number and finally the e-mail address.
    NSLog(((Contact *)[contactsArray objectAtIndex:currentRow]).fullName);
//    [[cell textLabel] setText:@"text"];//((Contact *)[contactsArray objectAtIndex:currentRow]).fullName];
//
//    // The rest info will be displayed in the detailsTextLabel of the cell.
//    [[cell detailTextLabel] setText:@"detail"];//((Contact *)[contactsArray objectAtIndex:currentRow]).phone];
    
    cell.textLabel.text = ((Contact *)[contactsArray objectAtIndex:currentRow]).fullName;
//    MKCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCell"];
//    
//    NSUInteger row = [indexPath row];
//    cell.
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


#pragma mark - IBActions
- (IBAction)addContact:(id)sender {
    // Init the contacts object.
    contacts = [[ABPeoplePickerNavigationController alloc] init];
    
    // Set the delegate.
	[contacts setPeoplePickerDelegate:self];
    
    // Set the e-mail property as the only one that we want to be displayed in the Address Book.
	[contacts setDisplayedProperties:[NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                                      [NSNumber numberWithInt:kABPersonFirstNameProperty],
                                      [NSNumber numberWithInt:kABPersonLastNameProperty],
                                      [NSNumber numberWithInt:kABPersonEmailProperty], nil]];
    
    /*
     kABPersonBirthdayProperty
     kABPersonCreationDateProperty
     kABPersonDepartmentProperty
     kABPersonFirstNamePhoneticProperty
     kABPersonFirstNameProperty
     kABPersonJobTitleProperty
     kABPersonLastNamePhoneticProperty
     kABPersonLastNameProperty
     kABPersonMiddleNamePhoneticProperty
     kABPersonMiddleNameProperty
     kABPersonModificationDateProperty
     kABPersonNicknameProperty
     kABPersonNoteProperty
     kABPersonOrganizationProperty
     kABPersonPrefixProperty
     kABPersonSuffixProperty
     kABPersonPhoneProperty
     */
    
    // Preparation complete. Display the contacts view controller.
    [self presentViewController:contacts animated:YES completion:nil];

}


#pragma mark - AddressBook Delegate Methods

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}


-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    
    // Get the first and the last name. Actually, copy their values using the person object and the appropriate
    // properties into two string variables equivalently.
    // Watch out the ABRecordCopyValue method below. Also, notice that we cast to NSString *.
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    // Compose the full name.
    NSString *fullName = @"";
    // Before adding the first and the last name in the fullName string make sure that these values are filled in.
    if (firstName != nil) {
        fullName = [fullName stringByAppendingString:firstName];
    }
    if (lastName != nil) {
        fullName = [fullName stringByAppendingString:@" "];
        fullName = [fullName stringByAppendingString:lastName];
    }
    

    
    // Get the multivalue e-mail property.
    CFTypeRef multivalue = ABRecordCopyValue(person, property);
    
    CFIndex index = ABMultiValueGetIndexForIdentifier(multivalue, identifier);
    
    // Copy the e-mail value into a string.
    NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multivalue, index);
    
    Contact *newContact = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Contact"
                     inManagedObjectContext:self.managedObjectContext];
    [newContact setFirstName:firstName];
    [newContact setLastName:lastName];
    [newContact setFullName:fullName];
    [newContact setPhone:phone];
    NSError *error;
    [contactsArray addObject:newContact];
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    

    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Contact"
                                   inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *array = [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:&error]];
    
    for(Contact *con in array)
    {
        NSLog(con.fullName);
        NSLog(con.phone);
        
    }
//    
//    sendgrid *msg = [sendgrid user:@"KimMoskowitz" andPass:@"Password42"];
//
//    msg.to = @"jared.moskowitz@tufts.edu";
//    msg.subject = @"NOTICE: Get Me Out Of Here";
//    msg.from = @"jaredmoskowitz123@gmail.com";
//    msg.text = @"hello world";
//    msg.html = @"<h1>hello world!</h1>";
//    
//    [msg sendWithWeb];
//    NSLog(@"%u",[self.table count]);
    // Reload the table to display the new data.
    [self.table reloadData];
    
    // Dismiss the contacts view controller.
    [contacts dismissViewControllerAnimated:YES completion:nil];
    
    
	return NO;
}



// Implement this delegate method to make the Cancel button of the Address Book working.
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
	[contacts dismissViewControllerAnimated:YES completion:nil];
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


@end
