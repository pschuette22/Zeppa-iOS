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
#import "ZPADefaulZeppatUserInfo.h"
#import "ZPAZeppaUserSingleton.h"


#import "GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship.h"
#import "GTLZeppausertouserrelationshipendpointCollectionResponseZeppaUserToUserRelationship.h"
#import "GTLServiceZeppausertouserrelationshipendpoint.h"
#import "GTLQueryZeppausertouserrelationshipendpoint.h"

#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@implementation ZPAFindMinglers

///**********************************************
#pragma mark - Private Methods
///**********************************************

-(void)executeZeppaApi;
{
    _recognizedEmails  = [[[ZPAZeppaUserSingleton sharedObject] getZeppaRecognizedEmails] mutableCopy];
    _recognizedNumbers = [[[ZPAZeppaUserSingleton sharedObject]getZeppaRecognizedNumbers ]mutableCopy];
    _uniqueInfoItems = [NSMutableArray array];
    [self getAllContacts];
}
-(void)getAllContacts{
    
    ZPAPhoneContact *cont = [[ZPAPhoneContact alloc]init];
    [cont getPhonContactInformation:^(NSArray *phoneNumbers, NSArray *emails, NSError *error) {
        
        __weak typeof(self)  weakSelf = self;
        if (!error) {
          
          NSString * recognizedEmailString = [self getEmailString:emails];
          NSString * recognizedNumberString = [self getNumberString:phoneNumbers];
         [weakSelf getZeppaUserInfoListQueryForEmailIds:recognizedEmailString andNumber:recognizedNumberString];
            
            NSLog(@"%@ emails ",recognizedEmailString);
            NSLog(@"%@ emails ",recognizedNumberString);
        }
        
    }];
    
}

-(NSString *)getEmailString:(NSArray *)emailArray{
    
    NSString *numberString = @"";
    
    for (int i=0; i<emailArray.count; i++) {
        if (![self numberIsRecognized:[emailArray objectAtIndex:i]]) {
        NSString * str = [NSString stringWithFormat:@"googleAccountEmail == '%@' ||",[emailArray objectAtIndex:i]];
        numberString =[numberString stringByAppendingString:str];
        }
    }
    
    if ([numberString length] > 2) {
        numberString = [numberString substringToIndex:[numberString length] - 2];
    }
    return numberString;
}
-(NSString *)getNumberString:(NSArray *)numberArray{
    
    NSString *numberString = @"";
    
    for (int i=0; i<numberArray.count; i++) {
        if (![self numberIsRecognized:[numberArray objectAtIndex:i]]) {
            NSString * str = [NSString stringWithFormat:@"primaryUnformattedNumber == %@ ||",[numberArray objectAtIndex:i]];
            numberString =[numberString stringByAppendingString:str];
        }
    }
    if ([numberString length] > 2) {
        numberString = [numberString substringToIndex:[numberString length] - 2];
    }
    return numberString;
}

-(BOOL)emailIsRecognized:(NSString *)email{
    
    for (NSString *emailString in _recognizedEmails) {
        if ([emailString isEqualToString:email]) {
            return YES;
        }
    }
    return NO;
}
-(BOOL)numberIsRecognized:(NSString *)number{
    
    for (NSString *numberString in _recognizedNumbers) {
        if ([numberString isEqualToString:number]) {
            return YES;
        }
    }
    return NO;
}
-(void)updateMingler{
    
    ZPAZeppaUserSingleton *user  = [ZPAZeppaUserSingleton sharedObject];
   
    
    for (GTLZeppauserinfoendpointZeppaUserInfo *useInfo in _uniqueInfoItems) {
        
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
-(void)getZeppaUserInfoListQueryForEmailIds:(NSString *)filterEmailId andNumber:(NSString *)filterNumberString{
    
    __weak typeof(self)  weakSelf = self;
    __block NSString *filter = filterEmailId;
    GTLQueryZeppauserinfoendpoint *listZeppaUserInfoTask = [GTLQueryZeppauserinfoendpoint queryForListZeppaUserInfo];
    [listZeppaUserInfoTask setFilter:filter];

    [[self zeppaUserInfoService] executeQuery:listZeppaUserInfoTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppauserinfoendpointCollectionResponseZeppaUserInfo *response, NSError *error)  {

        //
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
            
            for(GTLZeppauserinfoendpointZeppaUserInfo *userInfo  in response.items) {
                
                _defaultZeppaUser.zeppaUserInfo = userInfo;
                [_uniqueInfoItems addObject:userInfo];
                [_recognizedEmails addObject:userInfo.googleAccountEmail];
                
                [weakSelf getZeppaUserToUserRelationshipListQueryUsingCreatorIdwithCursor:nil anduserId:userInfo.key.parent.identifier];
                
            }
            [weakSelf getZeppaUserInfoListQueryForNumber:filterNumberString];
        }else{
            
            [weakSelf getZeppaUserInfoListQueryForNumber:filterNumberString];

        }
    }];
    
}

-(void)getZeppaUserInfoListQueryForNumber:(NSString *)filterNumber{
    
    
    __weak typeof(self) weakSelf = self;
    __block NSString *filter = filterNumber;
    
    GTLQueryZeppauserinfoendpoint *listZeppaUserInfoTask = [GTLQueryZeppauserinfoendpoint queryForListZeppaUserInfo];
    [listZeppaUserInfoTask setFilter:filter];
    
    [[self zeppaUserInfoService] executeQuery:listZeppaUserInfoTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppauserinfoendpointCollectionResponseZeppaUserInfo *response, NSError *error) {
        
        //
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
            
            for(GTLZeppauserinfoendpointZeppaUserInfo *userInfo  in response.items){
                
                _defaultZeppaUser.zeppaUserInfo = userInfo;
                [_uniqueInfoItems addObject:userInfo];
                [_recognizedNumbers addObject:userInfo.primaryUnformattedNumber];
                [weakSelf getZeppaUserToUserRelationshipListQueryUsingCreatorIdwithCursor:nil anduserId:userInfo.key.parent.identifier];
               
            }
           [weakSelf updateMingler];
        }else{
            NSLog(@"ok");
            [weakSelf updateMingler];
           [weakSelf getZeppaUserToUserRelationshipListQueryUsingCreatorIdwithCursor:nil anduserId:_defaultZeppaUser.zeppaUserInfo.key.parent.identifier];
        }
    }];
    
}

///***********************************************
#pragma  mark - Zeppa UserToUser RelationShip Api
///***********************************************
-(void)getZeppaUserToUserRelationshipListQueryUsingCreatorIdwithCursor:(NSString *)cursorValue anduserId:(NSNumber *)userId{
    
    __weak  typeof(self)  weakSelf = self;
    
    __block NSString *filter = [NSString stringWithFormat:@"creatorId == %@ && subjectId == %@ ",[ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier,userId];
    __block  NSString *ordering = @"created desc";
    __block NSNumber *limit = [NSNumber numberWithInt:50];
    
    GTLQueryZeppausertouserrelationshipendpoint *u2uRelationshipQuery = [GTLQueryZeppausertouserrelationshipendpoint queryForListZeppaUserToUserRelationship];
    
    [u2uRelationshipQuery setFilter:filter];
    [u2uRelationshipQuery setCursor:cursorValue];
    [u2uRelationshipQuery setOrdering:ordering];
    [u2uRelationshipQuery setLimit:[limit integerValue]];
    
    [self.zeppaUserRelationshipService executeQuery:u2uRelationshipQuery completionHandler:^(GTLServiceTicket *ticket,  GTLZeppausertouserrelationshipendpointCollectionResponseZeppaUserToUserRelationship *response, NSError *error) {
        //
        
        //  __strong typeof(self) strongSelf = weakSelf;
        //  __typeof__(self) strongSelf = weakSelf;
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
            
            for (GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *mingler in response.items) {
                [weakSelf fetchZeppaUserInfoWithParentIdentifier:mingler.subjectId withCompletion:^(GTLZeppauserinfoendpointZeppaUserInfo *info) {
                    
                    [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:info andRelationShip:mingler];
                 [weakSelf getZeppaUserToUserRelationshipListQueryUsingSubjectIdwithCursor:nil andSubjectId:userId];
                    
                    
                    
                }];
            }
            NSString *nextCursor = response.nextPageToken;
            if (nextCursor) {
                [weakSelf getZeppaUserToUserRelationshipListQueryUsingCreatorIdwithCursor:nextCursor anduserId:userId];
            }else{
               [weakSelf getZeppaUserToUserRelationshipListQueryUsingSubjectIdwithCursor:nil andSubjectId:userId];
            }
        }else{
            [weakSelf getZeppaUserToUserRelationshipListQueryUsingSubjectIdwithCursor:nil andSubjectId:userId];
        }
        [_delegate finishLoadingMingler];
    }];
    
}
-(void)getZeppaUserToUserRelationshipListQueryUsingSubjectIdwithCursor:(NSString *)cursorValue andSubjectId:(NSNumber *)subjectId{
    
    __block typeof(self)  weakSelf = self;
    __block NSString *filter = [NSString stringWithFormat:@"subjectId == %@ && creatorId == %@",[ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier,subjectId];
    __block  NSString *ordering = @"created desc";
    __block NSNumber *limit = [NSNumber numberWithInt:50];
    
    GTLQueryZeppausertouserrelationshipendpoint *u2uRelationshipQuery = [GTLQueryZeppausertouserrelationshipendpoint queryForListZeppaUserToUserRelationship];
    
    [u2uRelationshipQuery setFilter:filter];
    [u2uRelationshipQuery setCursor:cursorValue];
    [u2uRelationshipQuery setOrdering:ordering];
    [u2uRelationshipQuery setLimit:[limit integerValue]];
    
    [self.zeppaUserRelationshipService executeQuery:u2uRelationshipQuery completionHandler:^(GTLServiceTicket *ticket,  GTLZeppausertouserrelationshipendpointCollectionResponseZeppaUserToUserRelationship *response, NSError *error) {
        //
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
            
            for(GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *mingler in response.items) {
                [weakSelf fetchZeppaUserInfoWithParentIdentifier:mingler.creatorId withCompletion:^(GTLZeppauserinfoendpointZeppaUserInfo *info) {
                    
                    [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:info andRelationShip:mingler];
                    // [_delegate finishLoadingMingler];

                }];
                
            }
            NSString *nextCursor = response.nextPageToken;
            if (nextCursor) {
                [weakSelf getZeppaUserToUserRelationshipListQueryUsingSubjectIdwithCursor:nextCursor andSubjectId:subjectId];
            }else{
                
            }
            
        }else{
           [_delegate finishLoadingMingler];
        }
       [_delegate finishLoadingMingler];
    }];
    
}
-(GTLServiceZeppausertouserrelationshipendpoint *)zeppaUserRelationshipService{
    
    static GTLServiceZeppausertouserrelationshipendpoint *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppausertouserrelationshipendpoint alloc] init];
        service.retryEnabled = YES;
    }
    [service setAuthorizer:[ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
}

-(GTLServiceZeppauserinfoendpoint *)zeppaUserInfoService{
    
    static GTLServiceZeppauserinfoendpoint  *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppauserinfoendpoint  alloc] init];
        service.retryEnabled = YES;
    }
    [service setAuthorizer:[ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
}



@end
