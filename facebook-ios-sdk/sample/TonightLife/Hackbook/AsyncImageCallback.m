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
        imageView = imgView;
    }
    return self;
}

- (void) setImage:(UIImage*) image {
    imageView.image = image;
}

@end
