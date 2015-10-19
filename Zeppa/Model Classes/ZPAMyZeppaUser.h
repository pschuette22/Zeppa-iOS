//
//  ZPAUser.h
//  Zeppa
//
//  Created by Milan Agarwal on 30/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTLZeppaclientapiZeppaUser.h"


///This class is the wrapper class which wraps GTLZeppaclientapiZeppaUser class to include more data for zeppa user to be used in the app


///It is similar as MyZeppaUserMediator in android.
@interface ZPAMyZeppaUser : NSObject

@property (nonatomic, strong) GTLZeppaclientapiZeppaUser *endPointUser;
@property (nonatomic, strong) NSArray                       *arrEmails;
@property (nonatomic, strong) UIImage                       *profileImage;


@property(nonatomic, strong)NSMutableArray *tagsArray;


///Milan--> Below properties are not required for now

//@property (nonatomic, strong) NSString          *contactNumber;

///This will contain objects of class ZPACalendar
//@property (nonatomic, strong) NSMutableArray    *arrCalendars;
//@property (nonatomic, strong) NSArray           *arrFriends;
//@property (nonatomic, strong) NSString          *gender;


//@property (nonatomic, strong) NSString          *userId;
//@property (nonatomic, strong) NSString          *firstName;
//@property (nonatomic, strong) NSString          *lastName;
//@property (nonatomic, strong) NSString          *imageUrl;

///Next sync token and page token for incremental syncing of Calendar list
//@property (nonatomic, strong) NSString          *nextSyncTokenForCalendarList;

///Next sync token and page token for incremental syncing of Friends List
//@property (nonatomic, strong) NSString          *nextSyncTokenForFriendList;


@end
