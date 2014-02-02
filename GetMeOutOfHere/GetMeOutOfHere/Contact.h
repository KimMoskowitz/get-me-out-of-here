//
//  Contact.h
//  GetMeOutOfHere
//
//  Created by Jared Moskowitz on 2/2/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * email;

@end
