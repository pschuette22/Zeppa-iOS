//
//  ZPA.m
//  Zeppa
//
//  Created by Dheeraj on 09/06/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPACalendarModel.h"

static NSString * const kCalendarTitle = @"calendarTitle";
static NSString * const kCalendarId    = @"calendarId";
static NSString * const kCalendarColor = @"calendarColor";
static NSString * const kIsSync        = @"isSync";

@implementation ZPACalendarModel


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.calendarTitle forKey:kCalendarTitle];
    [encoder encodeObject:self.calendarId forKey:kCalendarId];
    [encoder encodeObject:self.calendarHexaColor forKey:kCalendarColor];
    [encoder encodeObject:@(self.calendarSync) forKey:kIsSync];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.calendarTitle     = [decoder decodeObjectForKey:kCalendarTitle];
        self.calendarId        = [decoder decodeObjectForKey:kCalendarId];
        self.calendarHexaColor = [decoder decodeObjectForKey:kCalendarColor];
        self.calendarSync      = [[decoder decodeObjectForKey:kIsSync] boolValue];
    }
    return self;
}

@end
