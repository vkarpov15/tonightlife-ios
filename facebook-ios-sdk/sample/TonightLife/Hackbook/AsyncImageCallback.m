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

- (AsyncImageCallback*) initWithImageView: (UIImageView*) imgView {
    self = [super init];
    if (self) {
        imageView = [imgView retain];
        activityIndicator = nil;
    }
    return self;
}

- (void) setImage:(UIImage*) image {
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (nil != activityIndicator) {
        [activityIndicator stopAnimating];
    }
    imageView.hidden = NO;
}

- (void) setActivityIndicator: (UIActivityIndicatorView*) indicator {
    activityIndicator = [indicator retain];
}

@end
