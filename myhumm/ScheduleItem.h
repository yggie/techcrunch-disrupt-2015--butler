//
//  ScheduleItem.h
//  MyButler
//
//  Created by Bryan Yap on 05/12/2015.
//  Copyright © 2015 Neetesh Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface ScheduleItem : NSObject

@property NSString *timeInfoText;
@property NSString *subtitle;
@property UIImage *image;

@property NSObject *info;

- (id)initWithInfo:(NSString*)startTime :(NSString*)endTime :(NSObject*)info :(UIImage*)image;

@end
