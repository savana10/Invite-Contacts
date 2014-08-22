//
//  ICContact.h
//  Invite Contacts
//
//  Created by Savana on 22/08/2014.
//  Copyright (c) 2014 Savana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AddressBook/AddressBook.h>

@interface ICContact : NSObject

@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (strong,nonatomic) NSString *fullName;
@property (strong,nonatomic) NSString *landlineNumber;
@property (strong,nonatomic) NSString *email;

@property (strong,nonatomic) NSData *imageData;

-(id) initWith:(ABRecordRef) record;


@end
