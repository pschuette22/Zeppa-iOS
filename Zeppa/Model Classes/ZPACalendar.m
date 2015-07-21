//
//  ZPACalendar.m
//  Zeppa
//
//  Created by Milan Agarwal on 06/09/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPACalendar.h"
static NSString * const kCalendarType = @"calendarType";
static NSString * const kCalendar     = @"calendar";
static NSString * const kShouldBeSync = @"shoudBeSync";

@implementation ZPACalendar
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:@(self.calendarType) forKey:kCalendarType];
    [encoder encodeObject:self.calendar forKey:kCalendar];
    [encoder encodeObject:@(self.shouldBeSynced) forKey:kShouldBeSync];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.calendarType = [[decoder decodeObjectForKey:kCalendarType] intValue];
        self.calendar = [decoder decodeObjectForKey:@"category"];
        self.shouldBeSynced = [[decoder decodeObjectForKey:@"subcategory"] boolValue];
    }
    return self;
}
@end
