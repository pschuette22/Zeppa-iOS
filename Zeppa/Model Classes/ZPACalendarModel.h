//
//  ZPA.h
//  Zeppa
//
//  Created by Dheeraj on 09/06/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPACalendarModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *calendarTitle;
@property (nonatomic, strong) NSString *calendarId;
@property (nonatomic, strong) NSString *calendarHexaColor;
@property (nonatomic, getter=isCalendarSync) BOOL calendarSync;
@end
