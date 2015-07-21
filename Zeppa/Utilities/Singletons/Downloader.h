//
//  Downloader.h
//  Nanaimohomes
//
//  Created by Atif Khan on 16/12/13.
//  Copyright (c) 2013 Agicent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Downloader;

typedef enum
{
    DownloaderState_Idle = 0, /// Downloaded is intialized, but downloading not started
    DownloaderState_Downloading,
    DownloaderState_Downloaded,
    DownloaderState_ErrorReceived,
    DownloaderState_Canceled
}DownloaderState;

@protocol DownloaderResponse <NSObject>

@required
/// Define this method to receive downloaded data, Data will be de referenced and set to nil once passed to delegate. So consumer of data if have to must reference with strong type
-(void)downloader:(Downloader*)downloader dataDownloaded:(NSData*)data;

@optional

-(void)downloader:(Downloader*)downloader errorDownloading:(NSError*)error;
-(void)downloader:(Downloader*)downloader responseRecieved:(NSURLResponse*)response;
-(void)beginDownloadingWithDownloader:(Downloader*)downloader;
-(void)downloader:(Downloader *)downloader progreessPercentage:(float )progress;
@end

@interface Downloader : NSObject

@property (nonatomic, assign) float progressDone;

@property (nonatomic, strong) id strongTagObj;

@property (nonatomic, readonly) DownloaderState downloaderState;

@property (nonatomic, readonly) NSURLRequest* request;

@property (nonatomic, assign) int itemIndex;

/// This property tell time taken in completion of Download, Default value is NSNotFound
@property (nonatomic, readonly) NSTimeInterval timetakenToDownloadInSeconds;

/**
 * @description It initialized downloader instance.
 * @param request It is request instance of item that need to be downloaded, It cannot be nil. It will send nil in case of nil request
 * @param delegate It is weak reference of Download Response Delegate
 * @result Returns the instance of Download after intializing it.
 */
-(instancetype) initWithRequest:(NSURLRequest*)request delegate:(id<DownloaderResponse>)delegate;

/// This method will start downloading if state is DownloaderState_Idle or DownloaderState_Canceled, which is after creation of instance. It can also be used to restart download
-(void)download;

/// At any point of time downloading can canceled or reset
-(void)cancel;




@end
