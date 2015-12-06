//
//  Food.m
//  myhumm
//
//  Created by Kankemwa Ishaku on 06/12/2015.
//  Copyright © 2015 Kankemwa Ishaku. All rights reserved.
//

#import "Food.h"

@implementation Food

- (id)name:(NSString *)name : (NSString *)estimated_delivery : (NSString *)image : (NSInteger)rating :(NSString*)restaurant {
    self.name = name;
    self.estimated_delivery = estimated_delivery;
    self.rating = rating;
    self.image = [UIImage imageNamed:image];
    self.restaurant = restaurant;
    return self;
}

@end
