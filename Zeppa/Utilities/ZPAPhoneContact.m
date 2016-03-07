//
//  ZPAPhoneContact.m
//  AddressBook
//
//  Created by Dheeraj on 14/04/15.
//  Copyright (c) 2015 Fafadia Tech, Mumbai. All rights reserved.
//

#import "ZPAPhoneContact.h"

@implementation ZPAPhoneContact{
    
    NSMutableArray *contactNumber;
    NSMutableArray *contactEmail;
}
-(id)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)getPhonContactInformation:(ContactInformationBlock)completion{
    
    
    
    [self checkAddressBookAccess];
    NSError *error = nil;
    if (contactNumber.count>0 || contactEmail.count>0) {
        
        completion(contactNumber,contactEmail,error);
    }
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:@"Contact Can't be Found" forKey:NSLocalizedDescriptionKey];
    // populate the error object with the details
    error = [NSError errorWithDomain:@"FetchingError" code:204 userInfo:details];
    completion(nil,nil,error);
    
}
-(void)checkAddressBookAccess
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    switch (ABAddressBookGetAuthorizationStatus())
    {
            // Update our UI if the user has granted access to their Contacts
        case  kABAuthorizationStatusAuthorized:
            [self accessGrantedForAddressBook:addressBook];
            break;
            // Prompt the user for access to Contacts if there is no definitive answer
        case  kABAuthorizationStatusNotDetermined :
            [self requestAddressBookAccess:addressBook];
            break;
            // Display a message if the user has denied or restricted access to Contacts
        case  kABAuthorizationStatusDenied:
        case  kABAuthorizationStatusRestricted:
        {
            [self showAlerView];

        }
            break;
        default:
            break;
    }
}
// Prompt the user for access to their Address Book data
-(void)requestAddressBookAccess:(ABAddressBookRef )addressBook
{
    typeof(self) __weak weakSelf = self;
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
        
        if (granted){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf accessGrantedForAddressBook:addressBook];
                                                         
            });
        }
        else{
            [self showAlerView];
        }
    });
}
// This method is called when the user has granted access to their address book data.
-(void)accessGrantedForAddressBook:(ABAddressBookRef )addressBook
{
    
    contactNumber = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
       
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        //For Phone number
        NSString* mobileLabel;
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                [contactNumber addObject:[self getPrimaryUnformattedNumber:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i)]];
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
               [contactNumber addObject:[self getPrimaryUnformattedNumber:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i)]];
                break ;
            }
            
        }
    }
       ///Fetching all email from contact
    
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    contactEmail = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
    
    for (CFIndex i = 0; i < CFArrayGetCount(people); i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
            NSString* email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, j);
            [contactEmail addObject:email];
            
        }
        CFRelease(emails);
    }
    CFRelease(addressBook);
    CFRelease(people);
    
}
-(void)showAlerView{
    
    NSString *message = @"This app does not have access to your Contacts.\n You can enable access at Privacy Settings";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(NSString *)getPrimaryUnformattedNumber:(NSString *)contactStr{
   
   // NSString *lastTenDigit;
    NSString *fileName = contactStr;
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    fileName = [[fileName componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    if(fileName.length >= 11){
        // get the last 11 characters
        
         fileName = [fileName substringFromIndex:[fileName length] - 11];
    } else if (fileName.length==10) {
        fileName = [NSString stringWithFormat:@"1%@",fileName];
    }
    
    return fileName;
}
@end
