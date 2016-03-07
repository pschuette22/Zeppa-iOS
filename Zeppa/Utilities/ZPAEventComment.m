//
//  ZPAEventComment.m
//  Zeppa
//
//  Created by Peter Schuette on 3/2/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPAEventComment.h"

@implementation ZPAEventComment


-(id) initWithComment:(GTLZeppaclientapiEventComment*) comment {
    if(self = [super init]){
        self.comment = comment;
        // TODO: get or fetch the commenter
    }
    return self;
}


@end
