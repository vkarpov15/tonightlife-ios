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
    urlToImage = [[NSMutableDictionary alloc] initWithCapacity:25];
    outstandingCalls = [[NSMutableSet alloc] initWithCapacity:25];
}

-(void) setImage: (NSURL*) url: (AsyncImageCallback*) callback {
    // Check imageCache for image, load it from internet if necessary, on separate thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage* image = [urlToImage objectForKey:[url absoluteString]];
        if (nil == image) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            [urlToImage setObject:image forKey:[url absoluteString]];
        }
        
        // Draw image on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Setting image for %@", [url absoluteString]);
            [callback setImage:image];
            [callback release];
        });
    });
}

@end
