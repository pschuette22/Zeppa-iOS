//
//  ZPAMyEventTag.h
//  Zeppa
//
//  Created by Peter Schuette on 3/3/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPAEventTagBase.h"

@interface ZPAMyEventTag : ZPAEventTagBase

-(id) initWithEventTag:(GTLZeppaclientapiEventTag *)tag;

-(BOOL) isMyTag;
-(void) deleteTag;

@end
