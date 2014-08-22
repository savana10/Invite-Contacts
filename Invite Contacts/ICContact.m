//
//  ICContact.m
//  Invite Contacts
//
//  Created by Savana on 22/08/2014.
//  Copyright (c) 2014 Savana. All rights reserved.
//

#import "ICContact.h"

@implementation ICContact
- (id)initWith:(ABRecordRef)record{
    
    self=[super init];
    if (self != nil) {
        // contact name
        
        _firstName= (__bridge NSString *)(ABRecordCopyValue(record, kABPersonFirstNameProperty));
        _lastName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonLastNameProperty));
        _fullName=@"";
        
        if (_firstName != nil) {
        _fullName= _firstName;
            _fullName= [_fullName stringByAppendingString:@" "];
        }
        
        if (_lastName != nil) {
            _fullName=[_fullName stringByAppendingString:_lastName];
        }
        // contact image
        CFDataRef imagData = ABPersonCopyImageData(record);
        _imageData = (__bridge NSData *)imagData;
        
        // contact number
        ABMutableMultiValueRef ref= ABRecordCopyValue(record, kABPersonPhoneProperty);
        
        if (ABMultiValueGetCount(ref) > 0) {
            // collect all phone in array
            
            for (CFIndex i = 0; i < ABMultiValueGetCount(ref); i++) {
                
                CFStringRef mobileRef = ABMultiValueCopyValueAtIndex(ref, i);
                //CFStringRef mobileLabel = ABMultiValueCopyLabelAtIndex(ref, i);
            
                _landlineNumber= (__bridge NSString *)(mobileRef);
                
                
            }
        }
        
        // contact email
        
        ABMultiValueRef emailRef= ABRecordCopyValue(record, kABPersonEmailProperty);
        
        if (ABMultiValueGetCount(emailRef) > 0) {
            for (CFIndex i= 0; i < ABMultiValueGetCount(emailRef); i++) {
                
                CFStringRef mailName= ABMultiValueCopyValueAtIndex(emailRef, 0);
                //CFStringRef mailLabel = ABMultiValueCopyLabelAtIndex(emailRef, i);
                _email= (__bridge NSString *)(mailName);
                
            }
        }
    }
    
    
    
    return self;
}

@end
