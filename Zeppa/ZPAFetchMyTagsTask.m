//
//  ZPAFetchMyTagsTask.m
//  Zeppa
//
//  Created by Peter Schuette on 3/17/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPAFetchMyTagsTask.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPAZeppaEventTagSingleton.h"

@implementation ZPAFetchMyTagsTask

// Initialize
-(id) initWithCompletionHandler:(void (^) (UIBackgroundFetchResult))handler {
    
    if(self=[super init]){
        // Handle further initialization
    }
    
    return self;
}

// Run the task
-(void) executeWithCompletion:(FetchMyTagsCompletionBlock)completionBlock {
    
    self.completionBlock = completionBlock;
    NSString *filter = [NSString stringWithFormat:@"ownerId==%@",[[ZPAZeppaUserSingleton sharedObject] getMyZeppaUserIdentifier]];
    NSString *cursor = nil;
    NSString *ordering=nil;
    NSInteger limit = 30;
    
    // Execute the fetch op
    [self fetchMyTagsWithFilter:filter withCursor:cursor withOrdering:ordering withLimit:limit];
    
}

-(void) fetchMyTagsWithFilter:(NSString*) filter withCursor:(NSString*) cursor withOrdering:(NSString*) ordering withLimit: (NSInteger)limit {
    
    __weak typeof (self) weakSelf = self;
    
    GTLQueryZeppaclientapi *fetchMyTagsTask = [GTLQueryZeppaclientapi queryForListEventTagWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    fetchMyTagsTask.filter = filter;
    fetchMyTagsTask.cursor = cursor;
    fetchMyTagsTask.ordering = ordering;
    fetchMyTagsTask.limit = limit;
    
    [[self service] executeQuery:fetchMyTagsTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseEventTag * response, NSError *error) {
        
        if(response && response.items && response.items.count>0){
            
            [[ZPAZeppaEventTagSingleton sharedObject] addMyEventTagsFromArray:response.items];

            if(response.items.count==limit){
                // returned the limit, there are likely more tags
                [weakSelf fetchMyTagsWithFilter:filter withCursor:response.nextPageToken withOrdering:ordering withLimit:limit];
            } else {
                [weakSelf onTaskCompletedWithError:nil];
            }
            
        } else {
            // Finish the completion process
            [weakSelf onTaskCompletedWithError:error];
        }
        
    }];
    
    
}

// Once it finishes, clean a few things up
-(void) onTaskCompletedWithError:(NSError*)error {
    // TODO: broadcast a message notifying the rest of the app fetch task did complete
    
    // Call the completion block if applicable
    if(self.completionBlock){
        self.completionBlock(nil,nil,error);
    }
}


// Service for fetching objects from Zeppa backend
-(GTLServiceZeppaclientapi *) service {
    static GTLServiceZeppaclientapi *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    
    return service;
}


@end
