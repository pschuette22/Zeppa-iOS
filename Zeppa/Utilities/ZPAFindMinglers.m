//
//  ZPAFindMinglers.m
//  Zeppa
//
//  Created by Faran on 24/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAFindMinglers.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPAPhoneContact.h"
#import "ZPAAuthenticatonHandler.h"
#import "ZPADefaultZeppaUserInfo.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPAConstants.h"


#import "GTLZeppaclientapiZeppaUserToUserRelationship.h"
#import "GTLZeppaclientapiCollectionResponseZeppaUserToUserRelationship.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"

#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@implementation ZPAFindMinglers {
    int queryCount;
}

///**********************************************
#pragma mark - Private Methods
///**********************************************

-(void)executeZeppaApi;
{
    _uniqueInfoItems = [NSMutableArray array];
    [self getAllContacts];
}
-(void)getAllContacts{
    
    ZPAPhoneContact *cont = [[ZPAPhoneContact alloc]init];
    [cont getPhonContactInformation:^(NSArray *phoneNumbers, NSArray *emails, NSError *error) {
        
        __weak typeof(self)  weakSelf = self;
        
        if(error) {
            // TODO: handle error
        } else if (emails.count > 0 && phoneNumbers.count > 0){
            queryCount=0;
            [weakSelf getZeppaUserInfoListQueryForEmails:emails andNumbers:phoneNumbers];

        } else {
            // Tell user they no contacts in their phone
        }
        
        
    }];
    
}


-(void)updateMingler{
    
    ZPAZeppaUserSingleton *user  = [ZPAZeppaUserSingleton sharedObject];
   
    
    for (GTLZeppaclientapiZeppaUserInfo *useInfo in _uniqueInfoItems) {
        
        [user addDefaultZeppaUserMediatorWithUserInfo:useInfo andRelationShip:nil];
        
        NSLog(@"%@",user); 
    }
   
   // [_delegate finishLoadingMingler];
}
///**********************************************
#pragma Address Book Methods
///**********************************************
- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    NSMutableArray *contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
        }
        
        //For Phone number
        NSString* mobileLabel;
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
                break ;
            }
            
        }
        [contactList addObject:dOfPerson];
        
    }
    NSLog(@"Contacts = %@",contactList);
    
    
}
///**********************************************
#pragma mark - Zeppa Api Call
///**********************************************
-(void)getZeppaUserInfoListQueryForEmails:(NSArray*)emails andNumbers:(NSArray*) numbers{
    
    
    /*
     * Iterate through the list of provided emails and query for users with these emails
     *
     */
    NSMutableArray *emailQueryList = [NSMutableArray array];
    int charCount = 0;
    if(emails.count > 0){
        for(NSString* email in emails){
            [emailQueryList addObject:email];
            charCount+=email.length;
            
            // If char count is greater than some amount, query for list
            if(charCount > 1850) {
                [self queryForZeppaUserInfoWithFilter:@"listParam.contains(authEmail)" withList:[NSArray arrayWithArray:emailQueryList]];
                [emailQueryList removeAllObjects];
                charCount=0;
            }
        }
        if(emailQueryList.count>0){
            [self queryForZeppaUserInfoWithFilter:@"listParam.contains(authEmail)" withList:[NSArray arrayWithArray:emailQueryList]];
        }
        
    }
    
    NSMutableArray *numberQueryList = [NSMutableArray array];
    charCount = 0;
    if(numbers.count > 0){
        for(NSString* number in numbers){
            [numberQueryList addObject:number];
            charCount+=number.length;
            
            // If char count is greater than some amount, query for list
            if(charCount > 1850) {
                [self queryForZeppaUserInfoWithFilter:@"listParam.contains(phoneNumber)" withList:[NSArray arrayWithArray:numberQueryList]];
                [numberQueryList removeAllObjects];
                charCount=0;
            }
        }
        if(numberQueryList.count>0){
            [self queryForZeppaUserInfoWithFilter:@"listParam.contains(phoneNumber)" withList:[NSArray arrayWithArray:numberQueryList]];
        }
        
    }
    
}

- (void)queryForZeppaUserInfoWithFilter:(NSString*) filter withList:(NSArray*) list{
    
    queryCount+=1;
    GTLQueryZeppaclientapi *listZeppaUserInfoTask = [GTLQueryZeppaclientapi queryForListZeppaUserInfoWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    // Set the limit
    listZeppaUserInfoTask.limit = list.count;
    listZeppaUserInfoTask.filter = filter;
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:list options:NSJSONWritingPrettyPrinted error:&jsonError];
    if (jsonData){
        
        listZeppaUserInfoTask.jsonArgs = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"jsonArgs: %@", listZeppaUserInfoTask.jsonArgs);
        [self.zeppaUserInfoService executeQuery:listZeppaUserInfoTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaUserInfo *response, NSError *error) {
            if(error){
                // There was an error
                NSLog(@"Error Querying for user info: %@", error.description);
            } else if (response && response.items && response.items.count>0) {
                // Iterate through response and add defaults
                for (GTLZeppaclientapiZeppaUserInfo *info in response) {
                    [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:info andRelationShip:nil];
                }
                // TODO: post a notification saying held user mediators has changed
            }
            
            queryCount-=1;
            if(queryCount>0){
                // Queries are still running, don't do anything
            } else {
                // Notify the device that we're no longer searching for people
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifDidFinishFindFriendsTask object:nil];
            }
        }];
    } else if (jsonError) {
        NSLog(@"json error: %@", jsonError.description);
    }
    
}


///***********************************************
#pragma  mark - Zeppa UserToUser RelationShip Api
///***********************************************

-(GTLServiceZeppaclientapi *)zeppaUserRelationshipService{
    
    static GTLServiceZeppaclientapi *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
}

-(GTLServiceZeppaclientapi *)zeppaUserInfoService{
    
    static GTLServiceZeppaclientapi  *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppaclientapi  alloc] init];
        service.retryEnabled = YES;
    }
    
    return service;
}



@end
