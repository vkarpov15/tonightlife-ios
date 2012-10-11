/**
 *  TLStreamingAudio.m
 *
 *  Created on: October 11, 2012
 *      Author: Valeri Karpov
 *
 *  Clean interface for streaming audio from a URL
 *
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TLStreamingAudio : NSObject {
    AVAudioPlayer* player;
}

@end
