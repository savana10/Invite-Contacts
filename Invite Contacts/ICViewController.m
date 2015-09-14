//
//  ICViewController.m
//  Invite Contacts
//
//  Created by Savana on 22/08/2014.
//  Copyright (c) 2014 Savana. All rights reserved.
//

#import "ICViewController.h"

@interface ICViewController ()

@end

@implementation ICViewController

NSMutableArray *allContacts,*selectedContacts;
UIAlertView *inviteContactsAlert;
BOOL message;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    message=true;
    float tableHeight = self.view.frame.size.height-(20+_bottomToolBar.frame.size.height);
    _contactsTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 20, 320, tableHeight)];
    [self.view addSubview:_contactsTableView];
    [self displayInviteMessage];
    
}
#pragma mark- display initial message
-(void) displayInviteMessage
{
    inviteContactsAlert =[[UIAlertView alloc] initWithTitle:@"Invite Contacts via" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Message",@"Mail", nil];
    [inviteContactsAlert show];
}
#pragma mark alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == inviteContactsAlert) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                
                message=true;
                [self checkAcesssPermission];
                break;
            case 2:
                message=false;
                [self checkAcesssPermission];
                break;
            
            default:
                break;
        }
    }
}

#pragma mark Check Access Permission
-(void) checkAcesssPermission
{

        if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
            NSLog(@"authorised");
            [self accessUserContacts];
        }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined){
            NSLog(@"not determined");
            [self accessUserContacts];
            
        }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
            NSLog(@"not authorised");
            [self displayAlert:@"Permission Denied" With:@"Grant permission to access contacts"];
            
        }
    
}
#pragma mark Access Contacts
-(void) accessUserContacts
{
    allContacts=[NSMutableArray new];
    selectedContacts=[NSMutableArray new];
    
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        
        if (granted) {
            NSLog(@"permission granted");
            
            ABAddressBookRef refAddressBook=ABAddressBookCreateWithOptions(NULL, nil);
            
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(refAddressBook);
            
            for (int i=0; i < CFArrayGetCount(allPeople); i++) {
                
                ABRecordRef record= CFArrayGetValueAtIndex(allPeople, i);
                ICContact *t=[[ICContact alloc] initWith:record];
                if (message) {
                    if (t.landlineNumber != NULL) {
                        [allContacts addObject:t];
                    }
                }else{
                    if (t.email != NULL) {
                        [allContacts addObject:t];
                    }
                }
                
            }
            
        dispatch_async(dispatch_get_main_queue(),^ {
//        display contacts in main thread
                    [self displayContacts];
                    
                });
        
            
        }else{
            NSLog(@"not granted");
            [self displayAlert:@"Permission Denied" With:@"Grant permission to access contacts"];
        }
    });
}

-(void) displayContacts
{
    [_contactsTableView setDelegate:self];
    [_contactsTableView setDataSource:self];
    [_contactsTableView reloadData];
}
#pragma mark- table view delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allContacts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId=@"contactCellId";
    
    UITableViewCell *contactCell=[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (contactCell == nil) {
        contactCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
       
        
    }

    __weak ICContact *tempContact=[allContacts objectAtIndex:indexPath.row];
    
    [contactCell.textLabel setText:tempContact.fullName];
    
    if (message) {
        contactCell.detailTextLabel.text= tempContact.landlineNumber;
    }else{
        contactCell.detailTextLabel.text= tempContact.email;
    }
    
    [contactCell.imageView setImage:[ICContactImage imageForContact:tempContact WithBG:ICContactImageDefaultColor]];
    
    
    if ([selectedContacts containsObject:tempContact]) {
        [contactCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [contactCell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return contactCell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICContact *temp=[allContacts objectAtIndex:indexPath.row];
    if ([selectedContacts containsObject:temp]) {
        [selectedContacts removeObject:temp];
    }else{
        [selectedContacts addObject:temp];
    }
    [_contactsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSString *st=@"Invite (";
    st=[st stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)selectedContacts.count]];
    st= [st stringByAppendingString:@")"];
    _inviteButton.title= st;

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    UILabel *headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 30)];
    [headerLabel setText:@"Invite Contacts"];
    [headerLabel setBackgroundColor:[UIColor whiteColor]];
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}
#pragma  mark  display alert message
-(void) displayAlert:(NSString *) title With:(NSString *) message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

#pragma mark - display options
- (IBAction)displayMessage:(id)sender {
    [self displayInviteMessage];
}
#pragma mark- send invitation

- (IBAction)sendInvitation:(id)sender {
    if (message) {
//         compose message
        
        if (selectedContacts.count >0) {
            [self composeMessage];
        }else{
            [self displayAlert:nil With:@"Please select atleast 1 contact"];
        }
        
    }else{
//         compose mail
        if (selectedContacts.count >0) {
            [self composeMail];
            
        }else{
            [self displayAlert:nil With:@"Please select atleast 1 contact"];
        }

    }
}
#pragma mark - send invitation via Message
-(void) composeMessage
{
    MFMessageComposeViewController *mvc=[[MFMessageComposeViewController alloc] init];
    NSMutableArray *selecNumbers=[NSMutableArray new];
    for (int j=0; j<selectedContacts.count; j++){
        ICContact *t=[selectedContacts objectAtIndex:j];
        [selecNumbers addObject:t.landlineNumber];
    }
    [mvc setRecipients:selecNumbers];
    [mvc setBody:@"This is a invite message"];
    [mvc setMessageComposeDelegate:self];
    if(mvc){
    [self presentViewController:mvc animated:true completion:nil];
    }
}
#pragma mark Message Delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            
            break;
        case MessageComposeResultSent:
            [self displayAlert:@"Success" With:@"Message Sent to all Invitees"];
            break;
        case MessageComposeResultFailed:
            [self displayAlert:@"Failure" With:@"Unable to send message, please try again later."];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:true completion:nil];
}
#pragma mark - send invitation via Mail

- (void) composeMail
{
    MFMailComposeViewController *mvc=[MFMailComposeViewController new];
    NSMutableArray *selecNumbers=[NSMutableArray new];
    for (int j=0; j<selectedContacts.count; j++){
        ICContact *t=[selectedContacts objectAtIndex:j];
        [selecNumbers addObject:t.email];
    }
    [mvc setToRecipients:selecNumbers];
    [mvc setSubject:@"Invite Subject"];
    [mvc setMessageBody:@"This is invite Messgae" isHTML:NO];
    [mvc setMailComposeDelegate:self];

    [self presentViewController:mvc animated:true completion:^{
    }];
}
#pragma mark Mail Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            
            break;
        case MFMailComposeResultFailed:
            [self displayAlert:@"Failure" With:@"Unable to send message, please try again later."];
            break;
        case MFMailComposeResultSaved:
            break;
            
        case MFMailComposeResultSent:
            [self displayAlert:@"Success" With:@"Mail Sent to all Invitees"];
            
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}

#pragma mark memory warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
