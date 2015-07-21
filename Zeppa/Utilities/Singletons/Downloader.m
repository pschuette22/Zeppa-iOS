//
//  Downloader.m
//  Nanaimohomes
//
//  Created by Atif Khan on 16/12/13.
//  Copyright (c) 2013 Agicent. All rights reserved.
//

#import "Downloader.h"

@interface Downloader()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSURLRequest * request_;
    DownloaderState downloaderState_;
    NSURLConnection *connection;
    NSMutableData *mData;
    
    NSTimeInterval startTimeInterval;
    NSTimeInterval endTimeInterval;
}
@property (nonatomic, assign) long long expectedLength;

@property (nonatomic, weak) id<DownloaderResponse>responseDelegate;

@end

@implementation Downloader

#pragma mark - Override Methods

-(NSURLRequest*)request
{
    return request_;
}

-(DownloaderState)downloaderState
{
    return downloaderState_;
}

-(NSTimeInterval)timetakenToDownloadInSeconds
{
    if (endTimeInterval == 0 || startTimeInterval == 0) {
        return  NSNotFound;
    }
    return (endTimeInterval - startTimeInterval);
}

-(void )callProgressDelegateIfDefined:(float) progressValueInPercentage
{
   // NSLog(@"Progress Completed: %f",progressValueInPercentage);
    if ([_responseDelegate respondsToSelector:@selector(downloader:progreessPercentage:)]) {
        [_responseDelegate downloader:self progreessPercentage:progressValueInPercentage];
    }
}

-(void)dealloc
{
    self.responseDelegate = nil;
    [self cancel];
}

#pragma mark - Public Methods

-(void)download
{
   
    if (downloaderState_ == DownloaderState_Idle || downloaderState_ == DownloaderState_Canceled)
    {
        downloaderState_    = DownloaderState_Downloading;
        
        startTimeInterval       = [NSDate timeIntervalSinceReferenceDate];
        endTimeInterval         = 0;
        if([_responseDelegate respondsToSelector:@selector(beginDownloadingWithDownloader:)])
        {
            [_responseDelegate beginDownloadingWithDownloader:self];
        }
        connection          = [[NSURLConnection alloc]
                               initWithRequest:request_
                               delegate:self
                               startImmediately:YES];
    }
}

-(void)cancel
{
    self.responseDelegate   = nil;
 
    [connection cancel];
    connection              = nil;
    downloaderState_        = DownloaderState_Canceled;
    mData                   = nil;
 
    startTimeInterval       = 0;
    endTimeInterval         = 0;
}

#pragma mark - Public Init method

-(instancetype)initWithRequest:(NSURLRequest *)request delegate:(id<DownloaderResponse>)delegate
{
    self = [super init];
    
    if (self) {
        if (!request) {
            return nil;
        }
        startTimeInterval       = 0;
        endTimeInterval         = 0;
        downloaderState_        = DownloaderState_Idle;
        request_                = request;
        self.responseDelegate   = delegate;
    }
    return self;
}

#pragma mark - NSURLConnection


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    downloaderState_ = DownloaderState_ErrorReceived;
    endTimeInterval = [NSDate timeIntervalSinceReferenceDate];
    
    if ([_responseDelegate respondsToSelector:@selector(downloader:errorDownloading:)])
    {
        [_responseDelegate downloader:self errorDownloading:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.expectedLength = [response expectedContentLength];
    if ([_responseDelegate respondsToSelector:@selector(downloader:responseRecieved:)]) {
        [_responseDelegate downloader:self responseRecieved:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!mData) {
        mData = [NSMutableData dataWithData:data];
    }else{
        [mData appendData:data];
    }
    
    if (_expectedLength>0) {
        float percentage = (mData.length/(double)_expectedLength)*100;
        self.progressDone = percentage;
        [self callProgressDelegateIfDefined:percentage];
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    downloaderState_ = DownloaderState_Downloaded;
    endTimeInterval = [NSDate timeIntervalSinceReferenceDate];

    [_responseDelegate downloader:self dataDownloaded:mData];
    mData = nil;
}


@end
