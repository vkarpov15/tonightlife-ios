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

@interface ImageCacheController : NSObject {
    NSMutableDictionary* urlToImage;
    NSMutableSet* outstandingCalls;
}

@end
