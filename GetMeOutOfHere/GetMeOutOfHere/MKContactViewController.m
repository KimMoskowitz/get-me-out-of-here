//
//  MKContactViewController.m
//  GetMeOutOfHere
//
//  Created by Jared Moskowitz on 2/1/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import "MKContactViewController.h"

@interface MKContactViewController ()

@end



@implementation MKContactViewController

@synthesize table;
@synthesize contactsArray;
@synthesize contacts;



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
    
    
    // Init the contactsArray.
    contactsArray = [[NSMutableArray alloc] init];

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
    return [contactsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Make sure to change the default style to the next one if you want to manage to display text
        // in the detailsTextLabel area.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell.
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    // Specify the current row.
    NSInteger currentRow = [indexPath row];
    
    // Display the selected contact's info.
    // First the full name, then the phone number and finally the e-mail address.
    [[cell textLabel] setText:[[contactsArray objectAtIndex:currentRow] objectAtIndex:0]];
    
    // The rest info will be displayed in the detailsTextLabel of the cell.
    [[cell detailTextLabel] setText:[[contactsArray objectAtIndex:currentRow] objectAtIndex:1]];
    
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
                                      [NSNumber numberWithInt:kABPersonLastNameProperty], nil]];
    
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
    
    // Get the index of the selected e-mail. Remember that the e-mail multi-value property is being returned as an array.
    CFIndex index = ABMultiValueGetIndexForIdentifier(multivalue, identifier);
    
    // Copy the e-mail value into a string.
    NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multivalue, index);
    
    // Create a temp array in which we'll add all the desired values.
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObject:fullName];
    
    // Save the email into the tempArray array.
    [tempArray addObject:phone];
    
    
    // Now add the tempArray into the contactsArray.
    [contactsArray addObject:tempArray];
    
    MKContact *newContact;
    [newContact setFullName:fullName];
    [newContact setFirstName:firstName];
    [newContact setLastName:lastName];
    [newContact setPhone:phone];
    
    // Reload the table to display the new data.
    [table reloadData];
    
    // Dismiss the contacts view controller.
    [contacts dismissViewControllerAnimated:YES completion:nil];
    
    
	return NO;
}


// Implement this delegate method to make the Cancel button of the Address Book working.
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
	[contacts dismissViewControllerAnimated:YES completion:nil];
}

@end
