/**
 *  AsyncImageCallback.m
 *
 *  Created on: September 4, 2012
 *      Author: Valeri Karpov
 *      
 *  Callback for changing a UIImageView asynchronously
 *  
 */

#import "AsyncImageCallback.h"

@implementation AsyncImageCallback 

- (void) setImage:(UIImage*) image {
    // Only call this from global queue thread
    dispatch_async(dispatch_get_main_queue(), ^{
        imageView.image = image;
    });
}

@end
