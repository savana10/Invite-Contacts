//
//  ICContactImage.h
//  Invite Contacts
//
//  Created by Savana on 22/08/2014.
//  Copyright (c) 2014 Savana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICContact.h"

#define ICContactImageDefaultColor [UIColor colorWithWhite:0.896 alpha:1.000]

@interface ICContactImage : NSObject
+ (UIImage *)imageForContact:(ICContact *)contact WithBG:(UIColor *) color;

@end
