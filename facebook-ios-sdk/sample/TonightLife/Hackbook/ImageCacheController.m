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
    }
    return self;
}

-(void) loadImageAsync: (NSURL*) url {
    [outstandingCalls setObject:[NSMutableData data] forKey:[url absoluteString]];
    [urlToCallbacks setObject:[[NSMutableArray alloc] initWithCapacity:25] forKey:[url absoluteString]];
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
        if (nil == [outstandingCalls objectForKey:[url absoluteString]]) {
            // This is our first callback for this image
            [self loadImageAsync:url];
            [[urlToCallbacks objectForKey:[url absoluteString]] addObject:callback];
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
    // Only handle callbacks in main UI thread!
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* url = [[[connection currentRequest] URL] absoluteString];
        NSLog(@"Loaded image %@", url);
        UIImage* img = [[UIImage alloc] initWithData:[outstandingCalls objectForKey:url]];
        [urlToImage setObject:img forKey:url];
        NSMutableArray* callbacks = [urlToCallbacks objectForKey:url];
        if (nil == callbacks) {
            NSLog(@"No callbacks!");
            return;
        }
        NSLog(@"Callbacks = %d", [callbacks count]);
        for (NSUInteger i = 0; i < [callbacks count]; ++i) {
            AsyncImageCallback* callback = [callbacks objectAtIndex:i];
            [callback setImage:img];
        }
    });
}

@end
