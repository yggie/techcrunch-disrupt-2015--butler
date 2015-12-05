//
//  ScheduleService.m
//  MyButler
//
//  Created by Bryan Yap on 05/12/2015.
//  Copyright © 2015 Neetesh Gupta. All rights reserved.
//

#include <stdlib.h>
#import "ScheduleService.h"

@implementation ScheduleService

- (NSArray*)someArray {
    NSMutableArray *array = [NSMutableArray new];
    
    [array addObject:[NSNumber numberWithInt:arc4random_uniform(74) ]];
    [array addObject:[NSNumber numberWithInt:arc4random_uniform(74) ]];
    [array addObject:[NSNumber numberWithInt:arc4random_uniform(74) ]];
    [array addObject:[NSNumber numberWithInt:arc4random_uniform(74) ]];
    
    return array;
}

@end
