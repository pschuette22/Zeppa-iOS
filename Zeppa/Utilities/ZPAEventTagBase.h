//
//  ZPAEventTagBase.h
//  Zeppa
//
//  Created by Peter Schuette on 3/3/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTLZeppaclientapiEventTag.h"
#import "ZPAUserInfoBase.h"

@protocol ZPAEventTagMethods <NSObject>

@required
-(BOOL) isMyTag;

@end

@interface ZPAEventTagBase : NSObject <ZPAEventTagMethods>

@property (strong, nonatomic) GTLZeppaclientapiEventTag *tag;
@property (strong, nonatomic) ZPAUserInfoBase *ownerInfo;

-(id) initWithEventTag:(GTLZeppaclientapiEventTag*) tag withOwner:(ZPAUserInfoBase*)owner;


@end
