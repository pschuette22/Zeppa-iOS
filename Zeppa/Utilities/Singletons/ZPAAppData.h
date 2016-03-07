//
//  ZPAAppData.h
//  Zeppa
//
//  Created by Milan Agarwal on 07/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GTLServiceTicket;
@class GTLCalendarCalendar;

//****************************************************
#pragma mark - Block Declaration
//****************************************************

///Create ZPAEndpointService Generic  Completion Block
typedef void(^ZPAGenericEndpointServiceCompletionBlock) (GTLServiceTicket *ticket, id object, NSError *error);


///This is a singleton class which will contain the app specific data to be used for complete session of the app.
@interface ZPAAppData : NSObject

///The logged in Zeppa User object
@property (nonatomic, strong)ZPAMyZeppaUser *loggedInUser;

///The Default user image to be used throughout the app
@property (nonatomic, strong) UIImage *defaultUserImage;


/*!
 * @description Creates the Singleton object of this class
 * @return will always return the Singleton object.
 */
+(instancetype)sharedAppData;


@end
