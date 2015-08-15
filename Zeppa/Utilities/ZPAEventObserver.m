//
//  ZPAEventObserver.m
//  Zeppa
//
//  Created by Peter Schuette on 8/15/15.
//  Copyright (c) 2015 Pete Schuette. All rights reserved.
//

#import "ZPAEventObserver.h"

@implementation ZPAEventObserver


-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    
    if ([keyPath isEqual:kObserveEventsChangedKey]){
        
    }
}

@end
