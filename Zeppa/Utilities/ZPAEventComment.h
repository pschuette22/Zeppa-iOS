//
//  ZPAEventComment.h
//  Zeppa
//
//  Created by Peter Schuette on 3/2/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPABaseEventsQuery.h"
#import "GTLZeppaclientapi.h"
#import "ZPAUserInfoBase.h"

@interface ZPAEventComment : NSObject

@property (nonatomic,strong) GTLZeppaclientapiEventComment *comment;
@property (nonatomic,strong) ZPAUserInfoBase *commenter;

-(id) initWithComment:(GTLZeppaclientapiEventComment*) comment;

@end
