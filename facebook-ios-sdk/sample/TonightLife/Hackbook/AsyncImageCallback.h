/**
 *  AsyncImageCallback.h
 *
 *  Created on: September 4, 2012
 *      Author: Valeri Karpov
 *      
 *  Callback for changing a UIImageView asynchronously
 *  
 */

#import <Foundation/Foundation.h>

@interface AsyncImageCallback : NSObject {
    UIImageView* imageView;
}

- (void) setImage:(UIImage*) image;

@end
