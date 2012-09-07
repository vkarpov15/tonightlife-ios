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
    UIActivityIndicatorView* activityIndicator;
}

- (AsyncImageCallback*) initWithImageView: (UIImageView*) imgView;

- (void) setActivityIndicator: (UIActivityIndicatorView*) indicator;

- (void) setImage:(UIImage*) image;

@end
