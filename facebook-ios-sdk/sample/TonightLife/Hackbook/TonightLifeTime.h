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

- (TonightLifeTime*) initWithNsDate: (NSDate*) d;

- (NSString*) makeYourTime;

- (NSComparisonResult) compare: (TonightLifeTime*)other;

@property (nonatomic,retain) NSDate* date;

@end
