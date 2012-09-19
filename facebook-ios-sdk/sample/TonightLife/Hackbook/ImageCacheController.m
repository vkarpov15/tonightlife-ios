/**
 *  ImageCacheController.h
 *
 *  Created on: September 4, 2012
 *      Author: Valeri Karpov
 *      
 *  Interface for loading and caching remote images
 *  
 */

#import "ImageCacheController.h"

@implementation ImageCacheController

-(ImageCacheController*) initDefault {
    self = [super init];
    if (self) {
        urlToImage = [[NSMutableDictionary alloc] initWithCapacity:25];
        outstandingCalls = [[NSMutableDictionary alloc] initWithCapacity:25];
        urlToCallbacks = [[NSMutableDictionary alloc] initWithCapacity:25];
    }
    return self;
}

-(void) loadImageAsync: (NSURL*) url {
    [outstandingCalls setObject:[NSMutableData data] forKey:[url absoluteString]];
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:
                            [NSURLRequest requestWithURL:url] delegate:self];
    
    [conn release];
}

-(void) preload: (NSURL*) url {
    [self loadImageAsync:url];
}

-(void) setImage: (NSURL*) url: (AsyncImageCallback*) callback {
    UIImage* image = [urlToImage objectForKey:[url absoluteString]];
    
    if (nil == image) {
        if (nil == [urlToCallbacks objectForKey:[url absoluteString]]) {
            // Make sure we've alloced a callback array BEFORE starting async load
            [urlToCallbacks setObject:[[NSMutableArray alloc] initWithCapacity:25] forKey:[url absoluteString]];
        }
        
        if (nil == [outstandingCalls objectForKey:[url absoluteString]]) {
            [[urlToCallbacks objectForKey:[url absoluteString]] addObject:callback];
            [self loadImageAsync:url];
        } else {
            [[urlToCallbacks objectForKey:[url absoluteString]] addObject:callback];
        }
    } else {
        [callback setImage:image];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [[outstandingCalls objectForKey:[[[connection currentRequest] URL] absoluteString]] appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Download failed!");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Only handle callbacks in main UI thread! This makes sure UIThread is
    // done adding callbacks
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* url = [[[connection currentRequest] URL] absoluteString];
        //NSLog(@"Loaded image %@", url);
        UIImage* img = [[UIImage alloc] initWithData:[outstandingCalls objectForKey:url]];
        [urlToImage setObject:img forKey:url];
        NSMutableArray* callbacks = [urlToCallbacks objectForKey:url];
        if (nil == callbacks) {
            return;
        }
        
        for (NSUInteger i = 0; i < [callbacks count]; ++i) {
            AsyncImageCallback* callback = [callbacks objectAtIndex:i];
            [callback setImage:img];
            // free callback
            [callback release];
        }
        
        // clean up callbacks array
        [urlToCallbacks removeObjectForKey:url];
        [callbacks release];
        // clean up data
        [outstandingCalls removeObjectForKey:url];
    });
}

@end
