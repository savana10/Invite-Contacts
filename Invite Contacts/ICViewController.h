//
//  ICViewController.h
//  Invite Contacts
//
//  Created by Savana on 22/08/2014.
//  Copyright (c) 2014 Savana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

#import "ICContact.h"
#import "ICContactImage.h"


@interface ICViewController : UIViewController<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
@property (strong,nonatomic) UITableView *contactsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *inviteButton;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;

@end
