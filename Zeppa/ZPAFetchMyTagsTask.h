//
//  ZPAFetchMyTagsTask.h
//  Zeppa
//
//  Created by Peter Schuette on 3/17/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPAFetchMyTagsTask : NSObject

// Handles completing the fetch task
typedef void (^FetchMyTagsCompletionBlock) (GTLServiceTicket *ticket, id object, NSError
                                  *error);
@property (nonatomic, copy) FetchMyTagsCompletionBlock completionBlock;


// Initialize
-(id) initWithCompletionHandler:(void (^) (UIBackgroundFetchResult))handler;

// Run the task
-(void) executeWithCompletion:(FetchMyTagsCompletionBlock)completionBlock;

// Once it finishes, clean a few things up
-(void) onTaskCompletedWithError:(NSError*)error;

@end
