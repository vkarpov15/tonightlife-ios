/**
 *  ImageCacheController.h
 *
 *  Created on: September 4, 2012
 *      Author: Valeri Karpov
 *      
 *  Interface for loading and caching remote images
 *  
 */

#import <Foundation/Foundation.h>

#import "AsyncImageCallback.h"

@interface ImageCacheController : NSObject<NSURLConnectionDelegate> {
    NSMutableDictionary* urlToImage;
    NSMutableDictionary* outstandingCalls;
    NSMutableDictionary* urlToCallbacks;
}

-(ImageCacheController*) initDefault;

-(void) loadImageAsync: (NSURL*) url;

-(void) preload: (NSURL*) url;
-(void) setImage: (NSURL*) url: (AsyncImageCallback*) callback;

@end
