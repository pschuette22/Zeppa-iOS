//
//  ZPAMyEventTag.m
//  Zeppa
//
//  Created by Peter Schuette on 3/3/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPAMyEventTag.h"
#import "ZPAZeppaUserSingleton.h"

@implementation ZPAMyEventTag

-(id) initWithEventTag:(GTLZeppaclientapiEventTag *)tag {
    if(self = [super initWithEventTag:tag withOwner:[ZPAZeppaUserSingleton sharedObject].getMyZeppaUser]){
        // Any other custom initialization that may come our way
    }
    return self;
}

/**
 *  Convenience
 */
-(BOOL) isMyTag {
    return YES;
}

/**
 *  Delete this users event tag
 */
- (void) deleteTag {
    // Delete tag in backend
    // Clean up app data to remove traces of this tag
}

@end
