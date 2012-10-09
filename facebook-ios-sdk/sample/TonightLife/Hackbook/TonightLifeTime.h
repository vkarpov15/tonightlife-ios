/**
 *  TonightLifeTime.h
 *
 *  Created on: September 1, 2012
 *      Author: Valeri Karpov
 *      
 *  Interface for event times
 *  
 */

#import <Foundation/Foundation.h>

@interface TonightLifeTime : NSObject {
    NSDate* date;
}

- (void) dealloc;

- (TonightLifeTime*) initWithNsDate: (NSDate*) d;

- (NSString*) makeYourTime;

- (NSComparisonResult) compare: (TonightLifeTime*) other;

- (NSTimeInterval) secondsUntil: (TonightLifeTime*) other;
- (BOOL) beforeNoon;

@property (nonatomic,retain) NSDate* date;

@end
