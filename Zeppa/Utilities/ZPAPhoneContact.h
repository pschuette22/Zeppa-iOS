//
//  ZPAPhoneContact.h
//  AddressBook
//
//  Created by Dheeraj on 14/04/15.
//  Copyright (c) 2015 Fafadia Tech, Mumbai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
typedef void(^ContactInformationBlock) (NSArray *phoneNumbers, NSArray *emails, NSError *error);
@interface ZPAPhoneContact : NSObject
-(void)getPhonContactInformation:(ContactInformationBlock)completion;
@end
