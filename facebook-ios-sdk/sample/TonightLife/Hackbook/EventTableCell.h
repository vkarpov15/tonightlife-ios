/**
 *  EventTableCell.h
 *
 *  Created on: August 23, 2012
 *      Author: Valeri Karpov
 *      
 *  Interface for design defined in EventCell.xib
 *  
 */

#import <UIKit/UIKit.h>

@interface EventTableCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *eventName;
@property (nonatomic, retain) IBOutlet UIView *imageWrapper;

@end
